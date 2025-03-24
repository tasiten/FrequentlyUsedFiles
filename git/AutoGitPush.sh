#!/bin/bash

# 設定
REPO_PATH="."  # カレントディレクトリ
COMMIT_MESSAGE="Batch commit"
BRANCH="main"  # 使用するブランチ
MAX_BATCH_SIZE=$((1 * 1024 * 1024 * 1024))  # 1GB（バイト単位）
MAX_FILE_SIZE=$((100 * 1024 * 1024))  # 100MB（バイト単位）

set -e  # エラー発生時にスクリプトを停止

# 色設定（視認性向上）
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${CYAN}🔍 スクリプト開始: Gitバッチ処理を実行します...${RESET}"

# リポジトリのパスへ移動
echo -e "${CYAN}📂 リポジトリのパスへ移動: $REPO_PATH${RESET}"
cd "$REPO_PATH" || { echo -e "${RED}❌ リポジトリの移動に失敗しました。${RESET}"; exit 1; }

# .gitignore に100MB以上のファイルを追加
echo -e "${CYAN}📝 100MB以上のファイルを.gitignoreに追加...${RESET}"
LARGE_FILES=$(find . -type f -size +"$MAX_FILE_SIZE"c | sed 's|^\./||')
if [ -n "$LARGE_FILES" ]; then
    echo "$LARGE_FILES" >> .gitignore
    git add .gitignore
    git commit -m "Ignore files larger than 100MB"
    git push origin "$BRANCH"
    echo -e "${GREEN}✅ .gitignoreを更新しました。${RESET}"
else
    echo -e "${YELLOW}⚠️ 100MBを超えるファイルは見つかりませんでした。スキップします。${RESET}"
fi

# 変更を取得
echo -e "${CYAN}🔍 新規ファイルを取得中...${RESET}"
FILES=$(git ls-files --others --exclude-standard)
FILE_COUNT=$(echo "$FILES" | wc -l)
echo -e "${GREEN}📄 新規ファイル数: $FILE_COUNT${RESET}"

# ファイルがなければ終了
if [ -z "$FILES" ]; then
    echo -e "${YELLOW}⚠️ 追加するファイルが見つかりません。処理を終了します。${RESET}"
    exit 0
fi

###############################################################################
# 事前スキャン: 実際に処理可能なファイル数 & 合計サイズを算出
###############################################################################
ACTUAL_FILE_COUNT=0
TOTAL_SIZE_TO_PROCESS=0
for f in $FILES; do
    FSZ=$(stat -c%s "$f" 2>/dev/null || echo -1)
    # stat に失敗 or 100MB以上のファイルは除外
    if [ "$FSZ" -lt 0 ] || [ "$FSZ" -ge "$MAX_FILE_SIZE" ]; then
        continue
    fi
    ACTUAL_FILE_COUNT=$((ACTUAL_FILE_COUNT + 1))
    TOTAL_SIZE_TO_PROCESS=$((TOTAL_SIZE_TO_PROCESS + FSZ))
done

echo -e "${CYAN}📊 実際に処理可能なファイル数: $ACTUAL_FILE_COUNT${RESET}"
echo -e "${CYAN}📊 実際に処理可能な合計サイズ: $((TOTAL_SIZE_TO_PROCESS / 1024 / 1024)) MB${RESET}"

# 進捗用の変数
CURRENT_BATCH_SIZE=0
FILES_TO_ADD=()
BATCH_COUNT=1
TOTAL_PROCESSED_SIZE=0
TOTAL_PROCESSED_FILES=0

echo -e "${CYAN}🚀 バッチ処理を開始します...${RESET}"

# 進捗表示用の関数（必要最低限）
print_progress() {
    # ファイル数の進捗 (パーセンテージ)
    if [ "$ACTUAL_FILE_COUNT" -gt 0 ]; then
        local file_pct=$((100 * TOTAL_PROCESSED_FILES / ACTUAL_FILE_COUNT))
    else
        local file_pct=0
    fi
    # サイズの進捗 (パーセンテージ)
    if [ "$TOTAL_SIZE_TO_PROCESS" -gt 0 ]; then
        local size_pct=$((100 * TOTAL_PROCESSED_SIZE / TOTAL_SIZE_TO_PROCESS))
    else
        local size_pct=0
    fi
    echo -e "${CYAN}📊 進捗: ファイル $TOTAL_PROCESSED_FILES/$ACTUAL_FILE_COUNT (${file_pct}%)" \
        " | サイズ $((TOTAL_PROCESSED_SIZE / 1024 / 1024))/${TOTAL_SIZE_TO_PROCESS_MB} MB (${size_pct}%)${RESET}"
}

# MB表記用の変数をあらかじめ計算
TOTAL_SIZE_TO_PROCESS_MB=$((TOTAL_SIZE_TO_PROCESS / 1024 / 1024))

for FILE in $FILES; do
    # stat コマンドが失敗したらスキップ
    FILE_SIZE=$(stat -c%s "$FILE" 2>/dev/null || echo -1)
    if [ "$FILE_SIZE" -lt 0 ]; then
        echo -e "${YELLOW}⚠️ スキップ: ${FILE} - statできません${RESET}"
        continue
    fi

    # 100MB以上のファイルはスキップ
    if [ "$FILE_SIZE" -ge "$MAX_FILE_SIZE" ]; then
        echo -e "${YELLOW}⚠️ スキップ: ${FILE} ($((FILE_SIZE / 1024 / 1024)) MB) - 100MB超過${RESET}"
        continue
    fi

    # 追加しても1GBを超えない場合
    if [ $((CURRENT_BATCH_SIZE + FILE_SIZE)) -le "$MAX_BATCH_SIZE" ]; then
        FILES_TO_ADD+=("$FILE")
        CURRENT_BATCH_SIZE=$((CURRENT_BATCH_SIZE + FILE_SIZE))
        TOTAL_PROCESSED_SIZE=$((TOTAL_PROCESSED_SIZE + FILE_SIZE))
        TOTAL_PROCESSED_FILES=$((TOTAL_PROCESSED_FILES + 1))

        echo -e "${CYAN}➕ 追加予定: ${FILE} ($((FILE_SIZE / 1024 / 1024)) MB)【現在のバッチサイズ: $((CURRENT_BATCH_SIZE / 1024 / 1024)) MB】${RESET}"
        
        # ファイルごとに進捗表示
        print_progress

    else
        # 1GBを超えそうな場合、一度コミット＆プッシュ
        echo -e "${CYAN}🚀 バッチ ${BATCH_COUNT} をコミット & プッシュ中..." \
            "（サイズ: $((CURRENT_BATCH_SIZE / 1024 / 1024)) MB, ファイル数: ${#FILES_TO_ADD[@]}）${RESET}"
        
        # 引数リストが長すぎるエラー回避のため、1ファイルずつ add
        for f in "${FILES_TO_ADD[@]}"; do
            # 万が一 "-" や空文字が混ざっていたらスキップ
            if [ -z "$f" ] || [ "$f" = "-" ]; then
                continue
            fi
            git add "$f"
        done
        
        git commit -m "$COMMIT_MESSAGE (Batch $BATCH_COUNT)"
        git push origin "$BRANCH"
        echo -e "${GREEN}✅ バッチ ${BATCH_COUNT} をプッシュ完了${RESET}"

        # 進捗報告
        echo -e "${CYAN}📊 進捗: 合計 ${TOTAL_PROCESSED_FILES} ファイル" \
            "/ $((TOTAL_PROCESSED_SIZE / 1024 / 1024)) MB プッシュ完了${RESET}"

        # 新しいバッチの準備
        FILES_TO_ADD=("$FILE")
        CURRENT_BATCH_SIZE="$FILE_SIZE"
        BATCH_COUNT=$((BATCH_COUNT + 1))

        # バッチ切り替え後に新規ファイルをカウント
        TOTAL_PROCESSED_SIZE=$((TOTAL_PROCESSED_SIZE + FILE_SIZE))
        TOTAL_PROCESSED_FILES=$((TOTAL_PROCESSED_FILES + 1))

        echo -e "${CYAN}➕ 新バッチに追加予定: ${FILE} ($((FILE_SIZE / 1024 / 1024)) MB)【現在のバッチサイズ: $((CURRENT_BATCH_SIZE / 1024 / 1024)) MB】${RESET}"
        
        # ファイルごとに進捗表示
        print_progress
    fi
done

# 最後のバッチをコミット＆プッシュ
if [ ${#FILES_TO_ADD[@]} -gt 0 ]; then
    echo -e "${CYAN}🚀 最後のバッチ ${BATCH_COUNT} をコミット & プッシュ中..." \
        "（サイズ: $((CURRENT_BATCH_SIZE / 1024 / 1024)) MB, ファイル数: ${#FILES_TO_ADD[@]}）${RESET}"

    for f in "${FILES_TO_ADD[@]}"; do
        # 万が一 "-" や空文字が混ざっていたらスキップ
        if [ -z "$f" ] || [ "$f" = "-" ]; then
            continue
        fi
        git add "$f"
    done
    
    git commit -m "$COMMIT_MESSAGE (Batch $BATCH_COUNT)"
    git push origin "$BRANCH"
    echo -e "${GREEN}✅ 最後のバッチをプッシュ完了${RESET}"
fi

# 最終結果
echo -e "${GREEN}🎉 すべてのファイルを追加、コミット、プッシュしました！${RESET}"
echo -e "${CYAN}📊 最終結果: 合計 ${TOTAL_PROCESSED_FILES} ファイル" \
    "/ $((TOTAL_PROCESSED_SIZE / 1024 / 1024)) MB をプッシュしました。${RESET}"

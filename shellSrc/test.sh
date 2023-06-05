#! /bin/bash

if [ ! -d ~/Downloads ]; then #Downloadsがない時
        echo "英語化実行"
        LC_ALL=C xdg-user-dirs-update --force
        rm -fr ダウンロード テンプレート デスクトップ ドキュメント ビデオ ピクチャ ミュージック 公開
fi

#壁紙単色に変更
gsettings set org.gnome.desktop.background picture-uri ""
gsettings set org.gnome.desktop.background primary-color '#123456'
#Anaconda起動
eval "$(~/anaconda3/bin/conda shell.bash hook)"
#! /bin/bash

#git init後のgit初期設定を行う．ユーザ名とメルアドを引数にできるが，引数がない場合は，omiがよく使うユーザ名とメルアドが自動的に設定される．

#引数がない場合
if [ $# -eq 0 ]; then
    echo "デフォルトのメールアドレスとユーザ名で登録します"
    git config --global user.email sniff_sniff@me.com
    git config --global user.name "tasiten"
    git config --global gui.encoding utf-8
    git config --global core.quotepath false
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto
    git config --global core.editor 'vim -c "set fenc=utf-8"'
#引数がある場合
else
    echo "引数が指定されました"
    git config --global user.email "$1"
    git config --global user.name "$2"
    git config --global gui.encoding utf-8
    git config --global core.quotepath false
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto
    git config --global core.editor 'vim -c "set fenc=utf-8"'
fi
echo ".gitconfigにメールアドレスとユーザ名を以下のように設定しました"
git config user.email
git config user.name

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# [ ! -d ~/.local/share/fonts ] && mkdir -p ~/.local/share/fonts
# mv HackGen_NF_v2.9.0/* ~/.local/share/fonts
# fc-cache /var/cache/fontconfig/

cp zshrc ~/.zshrc
cp fuya-omi.zsh-theme ~/.oh-my-zsh/themes/


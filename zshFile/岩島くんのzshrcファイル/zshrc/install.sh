yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
install_pid=$!
wait $install_pid

# [ ! -d ~/.local/share/fonts ] && mkdir -p ~/.local/share/fonts
# mv HackGen_NF/ ~/.local/share/fonts
# fc-cache /var/cache/fontconfig/

cp zshrc ~/.zshrc
cp fuya-omi.zsh-theme ~/.oh-my-zsh/themes/
source ~/.zshrc

chsh -s /bin/zsh {$USER}

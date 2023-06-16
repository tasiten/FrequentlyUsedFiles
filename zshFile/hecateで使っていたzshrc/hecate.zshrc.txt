# users generic .zshrc file for zsh(1)

#export XDG_RUNTIME_DIR=/run/user/$(id -u username)


## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

if [ "`uname`" = "Darwin" ]; then
    PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
fi

case ${UID} in
0)
    LANG=C
    ;;
esac
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'
setopt nohistreduceblanks


# Xilinx ISEの設定
#PATH=$PATH:/opt/Xilinx/12.2/ISE_DS/common/bin/lin:/opt/Xilinx/12.2/ISE_DS/PlanAhead/bin:/opt/Xilinx/12.2/ISE_DS/ISE/bin/lin:/opt/Xilinx/12.2/ISE_DS/ISE/sysgen/util:/opt/Xilinx/12.2/ISE_DS/EDK/bin/lin
XILINX_EDK=/opt/Xilinx/12.2/ISE_DS/EDK
XILINX=/opt/Xilinx/12.2/ISE_DS/ISE
XILINX_DSP=/opt/Xilinx/12.2/ISE_DS/ISE
XILINX_PLANAHEAD=/opt/Xilinx/12.2/ISE_DS/PlanAhead


export QUARTUS_ROOTDIR=/opt/altera/10.1sp1/quartus/

# ライセンスの設定（サイトごとに調整）
#export LM_LICENSE_FILE="26318@rh003;26318@rh007,26318@rh008,26318@rh002;"
export SYNPLCTYD_LICENSE_FILE=1709@rh000
export SYNPLIFYPRO_LICENSE_TYPE=synplifypremierdp

# パスの設定
#PATH=$PATH:/opt/VisualElite-4.2.1/Linux2.4/bin
#PATH=$PATH:/opt/synopsys/D-2010.03-SP1-1/bin
#PATH=$PATH:/opt/altera/10.1sp1/quartus/bin:/opt/altera/10.1sp1/modelsim_ase/bin
#PATH=$PATH:/opt/altera/11.0sp1/modelsim_ase/linux
#PATH=$PATH:/opt/altera/11.0sp1/quartus/bin:/opt/altera/11.0sp1/modelsim_ase/bin
#PATH=$PATH:/opt/altera/11.0sp1/modelsim_ase/linux

#PATH=/usr/local/texlive/p2011/bin/i686-pc-linux-gnu:/usr/local/texlive/p2009/bin/i686-pc-linux-gnu:$PATH
PATH=/usr/local/emacs/bin:/usr/local/insight/bin:/usr/local/teTeX/bin:/usr/local/eclipse:/usr/local/android-sdk-linux_x86/tools:$PATH

#export PATH=/opt/altera/13.0/quartus/bin/:opt/altera/13.0/modelsim_ase/linux/:$PATH





alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'


#alias ps="/bin/ps o user,pid,lwp,ppid,pgid,sid,tpgid,pri,pcpu,tty,s,cmd -L"
# ps aや ps axや ps xなど

# スタックサイズの設定(デフォルトでは小さすぎコンパイルエラーになることがある)
limit stacksize 16384

setopt print_eight_bit          # 補完候補リストの日本語を適正表示

# シェルが終了してもバックグラウンドジョブに HUP シグナルを送らないようにする
# 但し，ssh接続の場合はハングアップシグナルを出す
if [ ${SSH_CONNECTION} ]; then
 setopt no_check_jobs
 setopt hup
else 
 setopt NO_hup
fi


#unsetopt menu_complete 
zstyle ':completion:*:default' menu select=1    # 補完候補をカーソルキーで選択

setopt no_flow_control          # C-q, C-sを使わない
stty stop undef					# octaveなどではこれやらないとC-sでとまる

setopt magic_equal_subst        # =以降でも補完できるようにする( --prefix=/usrのような )

# Ctrl+wで､直前の/までを削除する｡
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


#eval `dircolors -b ~/.colorrc`
#eval `dircolors -b ~/dircolors.ansi-light`
#eval `dircolors -b ~/dircolors.ansi-dark`
# wget wget https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
# cp dircolors.ansi-dark .dircolors.ansi-dark
##eval `dircolors -b ~/.dircolors`


## Default shell configuration
#
# set prompt
#
autoload colors
colors
PROMPT='%U%m(%n)%#%u '
RPROMPT=' %U%~%u'
PROMPT2="%B%_>%b "                          # forやwhile/複数行入力時などに表示されるプロンプト
SPROMPT="%r is correct? [n,y,a,e]: "        # 入力ミスを確認する場合に表示されるプロンプト

# ファイルリスト補完でもlsと同様に色をつける｡
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}



setopt transient_rprompt                    # 右プロンプトに入力がきたら消す

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep


## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#
bindkey -e
bindkey "^[[1~" beginning-of-line # Home gets to line head
bindkey "^[[4~" end-of-line # End gets to line end
bindkey "^[[3~" delete-char # Del

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# 上下キーでヒストリサーチ
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "^[OA" history-beginning-search-backward-end
bindkey "^[OB" history-beginning-search-forward-end
# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete

# ディレクトリスタックに同じディレクトリを追加しないようになる
setopt pushd_ignore_dups

## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_all_dups
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        #  履歴を複数の端末で共有
setopt hist_no_store
setopt hist_reduce_blanks 
setopt extended_history     # 時刻を残す





# version 5.0.4以降でのみ
if [[ $ZSH_VERSION == (5.0.<4->)* ]]; then
    setopt hist_reduce_blanks # 余分な空白は詰めて登録
fi
setopt append_history # 複数のzshを同時に使用した際に履歴ファイルを上書きせず追加する

## Completion configuration
#
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit -u



## zsh editor
#
autoload zed


## Prediction configuration
#
#autoload predict-on
#predict-off



## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work


## GNU/Octave：以下の環境変数を書き換えておかないとC-cで落ちる
alias octave='DBUS_SESSION_BUS_ADDRESS="" /usr/bin/octave'
alias octave-cli='DBUS_SESSION_BUS_ADDRESS="" /usr/bin/octave-cli'
## Mozc用にgtkを無効化しておく
alias emacs='XMODIFIERS=@im=none emacs'

alias maxima="rlwrap maxima --disable-readline"

## backlight
alias xbl="xbacklight -set 100"


#alias ls="ls -F --color "
#alias ls='ls -CBFh --color=tty -I"#*#"'


alias ls='ls -CBFh --color=tty -I"#*#"'

alias tgif="env LC_ALL=ja_JP.EUC-JP tgif"


# SSH MOUNTの設定
if [ "`uname`" = "Linux" ]; then
    alias mnt_darkside="sshfs -o uid=$UID,gid=$GID,allow_other takago@darkside.info.kanazawa-it.ac.jp: ~/darkside"
    alias umnt_darkside="sudo umount -f -l ~/darkside"
    alias remnt_darkside="umnt_darkside;mnt_darkside"
fi
if [ "`uname`" = "Darwin" ]; then
    # MacはUTF8でも，濁点と半濁点の扱いがLinuxとは違うので以下のオプションを使わないと開けないフォルダが出てくるので注意するß
    alias mnt_darkside="sshfs -o modules=iconv,from_code=UTF-8,to_code=UTF-8-MAC,uid=$UID,gid=$GID,allow_other takago@darkside.info.kanazawa-it.ac.jp: ~/Desktop/darkside"
    alias umnt_darkside="sudo diskutil umount ~/Desktop/darkside"
    alias remnt_darkside="umnt_darkside;mnt_darkside"
fi


# gccの出力に色付けする
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'



# echoコマンドはビルトイン版を使わない
alias echo='/bin/echo'

#alias gcc=colorgcc 
#alias g++=colorgcc 
# alias make=colormake


## terminal configuration
#
case "${TERM}" in 
screen)
    preexec() {
	echo -ne "\ek${1%% *}\e\\"
    }
    precmd() {
	echo -ne "\ek[$(basename $(pwd))]\e\\"
    }

    TERM=xterm
    ;;
kterm*|xterm|*rxvt|gnome-terminal|mlterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac



# kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'
# 補完候補一覧でファイルの種別を識別マーク表示(ls -F の記号)
setopt list_types

# CTRLと左右カーソルで単語単位での移動(M-b,M-fと同じ)
# rxvtではきかないみたい．xterm,gnome-terminalではOK
bindkey "^[[1;2D" backward-word      # SHIFT+ ←
bindkey "^[[1;2C" forward-word      # SHIFT+ →
bindkey "^[[1;5C" forward-word      # CTRL+ ←
bindkey "^[[1;5D" backward-word        # CTRL+ →
bindkey "^[[1;3C" forward-word      # META  + ←
bindkey "^[[1;3D" backward-word        # META + →




# これうごかない
#if [ `/usr/bin/tty| sed 's/[0-9]//g'` = "/dev/tty" ] 
#then
#export LANG=C
##setterm -inversescreen on
#else
##    VSTRING=`xdpyinfo | grep "vendor string" | cut -f2 -d\:`
#    case "$VSTRING" in
#	*ASTEC*)
#	    export XMODIFIERS=@im=ASTEC_IMS
#	    ;;
#	*)
#	    ;;
#    esac
#fi


# 先行入力：便利だけど嫌な人はコメントアウトしよう
#autoload predict-on
#predict-on


# set_proxy none/manual/auto
function set_proxy() {
    if [ $1 = "none" ]; then
        gsettings set org.gnome.system.proxy mode 'none'
        unset https_proxy
        unset http_proxy
        unset ftp_proxy
    fi
    if [ $1 = "manual" ]; then    
        gsettings set org.gnome.system.proxy.http host 'wwwproxy.kanazawa-it.ac.jp'
        gsettings set org.gnome.system.proxy.http port 8080
        gsettings set org.gnome.system.proxy.ftp host 'wwwproxy.kanazawa-it.ac.jp'
        gsettings set org.gnome.system.proxy.ftp port 8080
        gsettings set org.gnome.system.proxy.https host 'wwwproxy.kanazawa-it.ac.jp'
        gsettings set org.gnome.system.proxy.https port 8080
        gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '*.local', '127.0.0.0/8', '10.0.0.0/8', '192.168.0.0/16', '202.13.0.0/16', '*.kanazawa-it.ac.jp' ]"    
        gsettings set org.gnome.system.proxy mode 'manual'        
        export https_proxy="http://wwwproxy.kanazawa-it.ac.jp:8080/"
        export http_proxy="http://wwwproxy.kanazawa-it.ac.jp:8080/"
        export ftp_proxy="http://wwwproxy.kanazawa-it.ac.jp:8080/"
    fi
    if [ $1 = "auto" ]; then
        gsettings set org.gnome.system.proxy mode 'auto' 
        gsettings set org.gnome.system.proxy autoconfig-url 'http://pac.kanazawa-it.ac.jp/proxy.pac'
    fi
}



alias lynx="lynx -nocolor"
alias wps="watch -n1 '/bin/ps o user,pid,lwp,pri,pcpu,pmem,vsz,size,tty,s,comm,stime -L'"
export PATH=${PATH}:/usr/local/ardrone-toolchain/bin

# 使用例：
# wifi_reconnect ardrone2_300619
function wifi_reconnect() {
    sudo nmcli dev disconnect iface wlan0
    sudo nmcli dev wifi connect $1 iface wlan0
    nmcli c s 
}

# 使用例：
# wifi off
# wifi on 
function wifi(){
    sudo nmcli radio wifi $1
}

# タッチパッド
function tpad() {
#  xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Device Enabled' $1
    xinput set-prop 'PS/2 Generic Mouse' 'Device Enabled' $1
    if [ $1 -eq 0 ]; then
        espeak "touch pad disable"
    else
        espeak "touch pad enable"
    fi
}

# unzip
export UNZIP="-O cp932"
export ZIPINFO="-O cp932"
function myunzip(){
    unzip $1 -d `basename $1 .zip`
}






###### ホスト探索
function lshost() {
    avahi-browse -alrpt 2> /dev/null |grep "IPv4" | cut -d ";" -f 7-8 | sort | uniq | awk -F ';' '/./{printf "%-30s %s\n",$1,$2}'
}

#### killコマンドの補間機能UP
zstyle ':completion:*:processes' command "ps -u $USER"

###### Anaconda
function myconda3(){
	echo "**** Anaconda 3 ****"
    export PATH=$HOME/anaconda3/bin:$PATH
}
function myconda2(){
	echo "**** Anaconda 2 ****"	
    export PATH=$HOME/anaconda2/bin:$PATH
}


## lsof
function wlsof() {
   CMDX="lsof -n -o -d0-20 -a -p 0,\`pgrep -x ${1} -d,\`";
   command /usr/bin/watch -n .1 "sh -c \"${CMDX}\"";
}

####################################################################
### コマンド履歴をキーボード(C-r)で検索できるようにする。(要：peco)
function peco-history-selection() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
                    eval $tac | \
                    peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

######################################################################
###
alias mnt_onedrive="rclone mount --daemon --vfs-cache-mode full myonedrive: ~/onedrive"
alias umnt_onedrive="fusermount -u -z ~/onedrive"

# snapやらtmpfsの表示が邪魔すぎるので，dfをシンプルにする
alias df="df -h -x tmpfs -x devtmpfs -x squashfs"

# ANACONDA
#. ${HOME}/anaconda3/etc/profile.d/conda.sh
source ~/anaconda3/etc/profile.d/conda.sh

#この一文で不適切なロケール設定を修正してくれる
eval $(/usr/bin/locale-check C.UTF-8)


#local triangle_right=$'\ue0b0'
#local triangle_left=$'\ue0b2'
local triangle_right=$''
local triangle_left=$''

local user_host="%B%F{green}${triangle_left}%f%K{green}%F{black}%n@%m %k%f%F{green}%K{cyan}${triangle_right}%k%f%b"
local current_dir="%B%K{cyan}%F{black}%~ %k%f%K{yellow}%F{cyan}${triangle_right}%f%k%b"
local vcs_branch='$(git_prompt_info)$(hg_prompt_info)'
local vsc_branch_color="%B%K{yellow}%F{black}${vcs_branch}%f%k%F{yellow}${triangle_right}%f%b"
local current_time_color="%F{cyan}${triangle_left}%f%K{cyan}%F{black}%*%k%f%F{cyan}${triangle_right}%f"
local user_symbol="%(!.#.$)"
local user_symbol_color="%K{cyan}%F{black} ${user_symbol}%k%f%F{red}${triangle_right}%f"
local rvm_ruby='$(ruby_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)$(conda_prompt_info)'
local docker='$(docker_prompt_info)'


virtualenv_prompt_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "%{%K{green}%F{white}${ZSH_THEME_VIRTUALENV_PREFIX}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX}%k%f%}"
  fi
}

conda_prompt_info() {
  if [ -n "${CONDA_DEFAULT_ENV}" ]; then
    echo "%{%K{green}%F{white}${ZSH_THEME_VIRTUALENV_PREFIX}${CONDA_DEFAULT_ENV}${ZSH_THEME_VIRTUALENV_SUFFIX}%k%f%}"
  fi
}

docker_prompt_info(){
    if [ -e /.dockerenv ]; then
        echo "%B%K{blue}%F{black}docker%f%k%F{blue}${triangle_right}%f%b"
    elif [ ! -e /.dockerenv ]; then
        echo "%B%K{blue}%F{black}%f%k%F{blue}${triangle_right}%f%b"
    fi
}

if [[ "${plugins[@]}" =~ 'kube-ps1' ]]; then
  local kube_prompt='$(kube_ps1)'
else
  local kube_prompt=''
fi

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"

PROMPT="╭─${venv_prompt}${user_host}${current_dir}${vsc_branch_color}${docker}
'-${current_time_color}${user_symbol_color}"


ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}● %f"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}✔ %f"

ZSH_THEME_HG_PROMPT_PREFIX="$ZSH_THEME_GIT_PROMPT_PREFIX"
ZSH_THEME_HG_PROMPT_SUFFIX="$ZSH_THEME_GIT_PROMPT_SUFFIX"
ZSH_THEME_HG_PROMPT_DIRTY="$ZSH_THEME_GIT_PROMPT_DIRTY"
ZSH_THEME_HG_PROMPT_CLEAN="$ZSH_THEME_GIT_PROMPT_CLEAN"

ZSH_THEME_RUBY_PROMPT_PREFIX="%K{magenta}%F{white} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="› %k%f"

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" ‹"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="› "

ZSH_THEME_VIRTUALENV_PREFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX"
ZSH_THEME_VIRTUALENV_SUFFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"

# anaconda実行
# Check if conda command is available and then initialize it
if [ -f "~/anaconda3/bin/conda" ]; then
    if [ -f "$HOME/anaconda3/bin/conda" ]; then
    # Anacondaによる仮想環境の表示を無効化する．
    conda config --set changeps1 false
fi

# venvによる仮想環境の表示を無効化する．
export VIRTUAL_ENV_DISABLE_PROMPT=1


# 上下矢印キーを押したとき，補完の重複を避けるためのカスタム履歴検索機能
function up-line-or-beginning-search-no-dups() {
    local -a up_hist
    up_hist=(${(u)history})
    zle up-line-or-beginning-search -n $up_hist
}
zle -N up-line-or-beginning-search-no-dups
bindkey '^[[A' up-line-or-beginning-search-no-dups

function down-line-or-beginning-search-no-dups() {
    local -a down_hist
    down_hist=(${(u)history})
    zle down-line-or-beginning-search -n $down_hist
}
zle -N down-line-or-beginning-search-no-dups
bindkey '^[[B' down-line-or-beginning-search-no-dups

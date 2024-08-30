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

virtualenv_prompt_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "%K{green}%F{white}${ZSH_THEME_VIRTUALENV_PREFIX}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX}%k%f"
  fi
}

conda_prompt_info() {
  if [ -n "${CONDA_DEFAULT_ENV}" ]; then
    echo "%K{green}%F{white}${ZSH_THEME_VIRTUALENV_PREFIX}${CONDA_DEFAULT_ENV}${ZSH_THEME_VIRTUALENV_SUFFIX}%k%f"
  fi
}

if [[ "${plugins[@]}" =~ 'kube-ps1' ]]; then
  local kube_prompt='$(kube_ps1)'
else
  local kube_prompt=''
fi

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"

PROMPT="╭─${user_host}${current_dir}${vsc_branch_color}
╰─${current_time_color}${user_symbol_color}"
RPROMPT="${venv_prompt}"

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

export VIRTUAL_ENV_DISABLE_PROMPT=1

# PROMPT="╭─${user_host}${current_dir}${rvm_ruby}${vcs_branch}${venv_prompt}${kube_prompt}
# ╰─%B${user_symbol}%b "
# RPROMPT="%B${return_code}%b"

# 仮想環境の表示を無効化する．
export VIRTUAL_ENV_DISABLE_PROMPT=1


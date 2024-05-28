#!/usr/bin/env zsh

local LAMBDA="%(?,%{$fg_bold[green]%}λ,%{$fg_bold[red]%}λ)"

# Função para verificar o estado do git e exibir informações apropriadas
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch_info=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "detached-head")
        local status_info=$(git status --porcelain 2> /dev/null)

        if [[ "$branch_info" == "detached-head" ]]; then
            echo "%{$fg[blue]%}detached-head%{$reset_color%} $(git_prompt_status)"
        else
            if [[ -z "$status_info" ]]; then
                echo "%{$fg[blue]%} ${branch_info}%{$reset_color%} %{$fg_bold[green]%}✔"
            else
                echo "%{$fg[blue]%} ${branch_info}%{$reset_color%} $(git_prompt_status)"
            fi
        fi
        echo "%{$fg_bold[cyan]%}→ "
    else
        echo "%{$fg_bold[cyan]%}→ "
    fi
}

function git_prompt_status() {
    local status_info=$(git status --porcelain 2> /dev/null)
    local symbols=""

    [[ -n $(echo "$status_info" | grep '^ M') ]] && symbols+="${ZSH_THEME_GIT_PROMPT_MODIFIED}"
    [[ -n $(echo "$status_info" | grep '^A ') ]] && symbols+="${ZSH_THEME_GIT_PROMPT_ADDED}"
    [[ -n $(echo "$status_info" | grep '^ D') ]] && symbols+="${ZSH_THEME_GIT_PROMPT_DELETED}"
    [[ -n $(echo "$status_info" | grep '^R ') ]] && symbols+="${ZSH_THEME_GIT_PROMPT_RENAMED}"
    [[ -n $(echo "$status_info" | grep '^U ') ]] && symbols+="${ZSH_THEME_GIT_PROMPT_UNMERGED}"
    [[ -n $(echo "$status_info" | grep '^\?\?') ]] && symbols+="${ZSH_THEME_GIT_PROMPT_UNTRACKED}"
    [[ -n $(git stash list) ]] && symbols+="${ZSH_THEME_GIT_PROMPT_STASHED}"

    echo "$symbols"
}

function get_right_prompt() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n "%{$fg_bold[white]%}[%{$fg_bold[blue]%}$(git rev-parse --short HEAD)%{$fg_bold[white]%}]%{$reset_color%}"
    else
        echo -n "%{$reset_color%}"
    fi
}

PROMPT=$''$LAMBDA'\
 %{$fg_no_bold[magenta]%}[%'${LAMBDA_MOD_N_DIR_LEVELS:-3}'~]\
 $(check_git_prompt_info)\
%{$reset_color%}'

RPROMPT='$(get_right_prompt)'

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="at %{$fg[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✔"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}✘"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}»"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"

ZSH_THEME_GIT_PROMPT_SHOW="${ZSH_THEME_GIT_PROMPT_SHOW=true}"
ZSH_THEME_GIT_PROMPT_COLOR="${ZSH_THEME_GIT_PROMPT_COLOR="red"}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[blue]%}$"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg_bold[white]%}^"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg_bold[white]%}[%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg_bold[white]%}]"

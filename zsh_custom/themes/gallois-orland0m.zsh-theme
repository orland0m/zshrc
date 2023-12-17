# This is a fork from: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/gallois.zsh-theme

autoload -U colors && colors

NEWLINE=$'\n'
base_prompt="%{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B${NEWLINE}$%b "
custom_prompt=""
last_run_time=""

function pipestatus_parse {
  PIPESTATUS="$pipestatus"
  ERROR=0
  for i in "${(z)PIPESTATUS}"; do
      if [[ "$i" -ne 0 ]]; then
          ERROR=1
      fi
  done

  if [[ "$ERROR" -ne 0 ]]; then
      print "[%{$fg[red]%}$PIPESTATUS%{$fg[cyan]%}]"
  fi
}

# Combine it all into a final right-side prompt
PROMPT='%{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
function preexec() {
    last_run_time=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
}

function duration() {
    local duration
    local now=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
    local last=$1
    local last_split=("${(@s/./)last}")
    local now_split=("${(@s/./)now}")
    local T=$((now_split[1] - last_split[1]))
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    local s=$(((now_split[2] - last_split[2]) / 1000000000.))
    local m=$(((now_split[2] - last_split[2]) / 1000000.))

    (( $D > 0 )) && duration+="${D}d"
    (( $H > 0 )) && duration+="${H}h"
    (( $M > 0 )) && duration+="${M}m"

    if [[ $S -le 0 ]]; then
        printf "%ims" "$m"
    else
        if ! [[ -z $duration ]] && printf "%s" "$duration"
        local sec_milli=$((S + s))
        printf "%.3fs" "$sec_milli"
    fi
}

function host_detail() {
  if [ "$SSH_CONNECTION" ]; 
  then
        echo "%{$fg[yellow]%}[%n@%m]"
  else
        echo ""
  fi
}

function precmd() {
    RETVAL=$(pipestatus_parse)
    local info=""
    local prompt_prefix=$(host_detail)

    if [ ! -z "$last_run_time" ]; then
        local elapsed=$(duration $last_run_time)
        last_run_time=$(print $last_run_time | tr -d ".")
        if [ $(( $(perl -MTime::HiRes=time -e 'printf "%.9f\n", time' | tr -d ".") - $last_run_time )) -gt $(( 120 * 1000 * 1000 * 1000 )) ]; then
            local elapsed_color="%{$fg[magenta]%}"
        elif [ $(( $(perl -MTime::HiRes=time -e 'printf "%.9f\n", time' | tr -d ".") - $last_run_time )) -gt $(( 60 * 1000 * 1000 * 1000 )) ]; then
            local elapsed_color="%{$fg[red]%}"
        elif [ $(( $(perl -MTime::HiRes=time -e 'printf "%.9f\n", time' | tr -d ".") - $last_run_time )) -gt $(( 10 * 1000 * 1000 * 1000 )) ]; then
            local elapsed_color="%{$fg[yellow]%}"
        else
            local elapsed_color="%{$fg[green]%}"
        fi
        info=$(printf "%s%s%s%s%s" "%{$fg[cyan]%}[" "$elapsed_color" "$elapsed" "%{$fg[cyan]%}]" "$RETVAL")
        unset last_run_time
    fi

    [ -z "$info" ] && custom_prompt="$prompt_prefix$base_prompt" || custom_prompt="$prompt_prefix$info$base_prompt"
}

setopt PROMPT_SUBST
PROMPT='$custom_prompt'

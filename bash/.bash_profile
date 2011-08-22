[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

function parse_git_deleted {
  [[ $(git status 2> /dev/null | grep deleted:) != "" ]] && echo "-"
}
function parse_git_added {
  [[ $(git status 2> /dev/null | grep "Untracked files:") != "" ]] && echo '+'
}
function parse_git_modified {
  [[ $(git status 2> /dev/null | grep modified:) != "" ]] && echo "*"
}
function parse_git_dirty {
  # [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "☠"
  echo "$(parse_git_added)$(parse_git_modified)$(parse_git_deleted)"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

BLACK="\[\033[0;30m\]"
DARK_GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"
BLUE="\[\033[0;34m\]"
LIGHT_BLUE="\[\033[1;34m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
RED="\[\033[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
PURPLE="\[\033[0;35m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
BROWN="\[\033[0;33m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
DEFAULT_COLOR="\[\033[00m\]"

export PS1="\`if [ \$? = 0 ];
    then
      echo -e '$GREEN\u@\h $LIGHT_BLUE\w $YELLOW$(parse_git_branch)$ $DEFAULT_COLOR';
    else
      echo -e '$LIGHT_RED\u@\h $LIGHT_BLUE\w $YELLOW$(parse_git_branch)$ $DEFAULT_COLOR';
    fi; \`"


#export PS1='\u@\h \w $(parse_git_branch)$ '

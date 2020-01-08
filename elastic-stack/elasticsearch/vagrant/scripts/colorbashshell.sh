# ### Set the prompt like "username@hostname:~ $"
# # See: http://www.cyberciti.biz/faq/bash-shell-change-the-color-of-my-shell-prompt-under-linux-or-unix/
# # And: http://mywiki.wooledge.org/BashFAQ/037

RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"
WHITE="\[\033[1;37m\]"
RESET="\[\033[0m\]"

#Christmas Theme
# if [ $(id -u) -eq 0 ];
# then # you are root, set red colour prompt
# PS1="[$RED\u$RESET$WHITE@\h$RESET$GREEN \W$RESET]\$ "
# else # normal
# PS1="[$GREEN\u$RESET$WHITE@\h$RESET$RED \W$RESET]\$ "
# fi

if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
PS1="[$RED\u$RESET$CYAN@\h$RESET$PURPLE \W$RESET]\$ "
#PS1='\e[s\e[0;0H\e[1;33m\h    \t\n\e[1;32mThis is my computer\e[u[\u@\h:  \w]\$ '
else # normal
PS1="[$GREEN\u$RESET$CYAN@\h$RESET$PURPLE \W$RESET]\$ "
fi


export PATH=$HOME/bin:$PATH
alias vi=vim

PROMPT_DIRTRIM=2
PS1='[\u@\h \W]$ '

alias ls='ls --color'
LS_COLORS='ow=36;01:di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=36:*.rpm=90'
export LS_COLORS

cd ~/git

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /data/data/com.termux/files/home/.npm/_npx/10302/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /data/data/com.termux/files/home/.npm/_npx/10302/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /data/data/com.termux/files/home/.npm/_npx/10302/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /data/data/com.termux/files/home/.npm/_npx/10302/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash


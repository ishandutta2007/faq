# echo 'DEBUG [~/.profile]'
source ~/.bashrc
source ~/project/current/cfg/current.cfg

# shell

# Attribute codes:
# 0=none 1=bold 4=underscore 5=blink 7=reverse 8=concealed
# Text color codes:
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
# Background color codes:
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white

mT="\e[0;32m"
mB="\e[1;41m"
m1="\["
m2="\e[0m"
PS1="\n${m1}${mB}\h${m2}:\w\n[\t \u] "
#PS1="[\D{%Y.%m.%d %T} \u@\h:\w ] $ "
#PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]> '
umask 0002
unalias ls 2>/dev/null
##history per box
#mkdir -p ${HOME}/.hist_per_box
#export HISTFILE="${HOME}/.hist_per_box/bash_history.`hostname`"
##history shared
HISTFILE="${HOME}/.bash_history"
HISTTIMEFORMAT="[%Y.%m.%d-%T] "
HISTSIZE=1000000

alias xterm='xterm -bg "gray" -fs 12 -geometry "80x24+0+0" -fn "-*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1"'
#alias xterm='xterm -vb -bg "gray" -fs 12 -geometry "80x24+0+0" -fn "-*-terminus-medium-*-*-*-18-*-*-*-*-*-iso10646-1"'
#alias updatedb='updatedb --add-prunepaths "/mnt/nfs"'

# aliases

# svn
alias svna="svn ci --username aUser -m "
alias svnal="svn list http://svn.dev.domain.com/svn/project"
alias svnad="svn diff -r PREV"
alias svnai="export EDITOR=/usr/bin/vim;svn propedit svn:ignore ."
alias svnarmvc="svn rm --keep-local"
alias svnaadde="svn add --depth=empty"

# git
alias gitadiff="git diff master"
alias gitadiff3='git diff $(git log -1 --before="3 days ago" --format=%H)'
alias gitaadd="git add "
alias gitastatus="git status -uno"
alias gitaciall="git commit -a -m "
alias gitaci="git commit -m "
alias gitapull="git pull --rebase"
alias gitauncache="git rm --cached"
alias gitalogp="git log -p"
alias gitalog="git log --"
alias gitalogstat="git log master --stat"
alias gitashowstat="git show --stat"
alias gitapush="git push"
alias gitaresets="git reset --soft HEAD^"
alias gitareseth="git reset --hard HEAD^"
alias gitafixmerge="git commit -am"
alias gitafinddelete="git log --diff-filter=D --summary | grep delete"
alias gitacod='git checkout documentation'
alias gitacom='git checkout master'

#java/tools
JAVA_HOME='/apps/tools/java/latest'
alias jconsole="${JAVA_HOME}/bin/jconsole"
alias jvisualv="${JAVA_HOME}/bin/jvisualvm"
alias jpsa="${JAVA_HOME}/bin/jps -lv"
alias jstatgca="${JAVA_HOME}/bin/jstat -gcutil"
alias jstatclassa="${JAVA_HOME}/bin/jstat -class"
alias jstatcompilera="${JAVA_HOME}/bin/jstat -compiler"
#java/utils
alias gcviewer="${JAVA_HOME}/bin/java -jar /apps/tools/java/gcviewer/gcviewer-1.35-SNAPSHOT.jar"
alias garbagecat="${JAVA_HOME}/bin/java -jar /apps/tools/java/garbagecat-1.0.1.jar"
alias listcurusr="w | grep -v '^USER' | sed 's/ .*//' | sort | uniq | xargs finger | grep Name"

# tools/general
alias findChange="find . -cmin -1440"
alias diffa="diff -b -C 0 "
alias xa='Xvfb :3 -extension GLX -screen 0 800x600x16& DISPLAY=:3 /usr/bin/openbox-session&'
alias vnca='vncserver :3 -rfbauth ~/vnc/vncpass -geometry 1920x1080'
alias vncar='vncserver -kill :3 ; vnca'
alias vnc11a='x11vnc -display :3 -rfbauth ~/vnc/vncpass -geometry 1920x1080 -viewpasswd guest'
alias fixshares='service rpcbind restart;service ypbind restart;service autofs restart'
alias gunicorn='gunicorn -b 127.0.0.1:8000 httpbin:app'

#wireshark
alias wireshark="xhost local:root; sudo DISPLAY=$DISPLAY wireshark"

if [ -x /bin/vi ];then alias vi='vi +":syntax off"'; fi
if [ -x /usr/bin/vim ];then alias vi='vim +":syntax off"'; fi
if [ -x /usr/bin/vim ];then alias vim='vim +":syntax off"'; fi


#paths
PATH=~/bin/:/apps/tools/java/latest/bin:$PATH

#locales
#export LANG="en_US.UTF-8"
LANG="C"
LANGUAGE="en_US:en"

#others
# tar -cf - dir | pbzip2 > ~/dir.tar.bzip2

#################################
#functions

function f_decode_vnc_list_to_user {
 for vnc_line in $(ps -ef | grep Xvnc | grep ':' | grep -v grep | awk '{print $9"|"$2"|"$1}')
 do
  vnc_display=$(echo ${vnc_line} | awk -F '|' '{print $1}')
  vnc_pid=$(echo ${vnc_line} | awk -F '|' '{print $2}')
  vnc_user=$(echo ${vnc_line} | awk -F '|' '{print $3}' | xargs finger | grep Login | sed 's/Login:\s\+//;s/\s\+Name:/:/')
  echo "Display [${vnc_display}], pid [${vnc_pid}], user [${vnc_user}]"
 done
}


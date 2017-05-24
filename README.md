# Ubuntu / Debian
```
apt-get install ssmtp mailutils zsh shellcheck
apt-get update	&& apt-get upgrade -y && apt-get dist-upgrade -y
apt-get clean -y &&  apt-get autoclean -y && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}

apt-get gcc make git autoconf autogen automake vim mlocate net-tools tcpdump zsh
sh -c "$(wget https://raw.githubusercontent.com/T0FFF/oh-my-zsh/master/tools/install.sh -O -)"
echo "source /home/$USER/.zshrc" > /root/.zshrc

apt-get install openswan=1:2.6.37-3
or
apt-mark hold openswan
=> openswan passé en figé (« hold »).
dpkg -l | grep openswan
=> hi  openswan                                  1:2.6.37-3
au lieu de "ii  openswan                                  1:2.6.37-3"
apt-mark unhold openswan
=> Annulation de l'état figé pour openswan.

echo "Europe/Paris" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
or 
dpkg-reconfigure tzdata 

update-manager -d
ou
do-release-upgrade -d

lsb_release -d
-----------------------------------------------
/etc/sudoers
<user> ALL=(ALL) NOPASSWD: ALL
-----------------------------------------------

Disable lock screen
xset -dpms
xset s off
setterm -powersave off  (ctrm + Alt + 1-6 to switch to cmd to text interface)

gnome-shell
vim /usr/share/themes/Adwaita/metacity-1/metacity-theme-3.xml
title_vertical_pad => 0
gnome-tweak-tool > polices / fonts

Install source
apt-get install build-essential dpkg-dev linux-headers-$(uname -r)

if [ $(whoami) = "root" ]
then
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/local/sbin:/usr/sbin:/sbin"
else
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
fi


```

# Docker
```
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
-----------------------------------------------------------------------------
Docker iptables 
http://blog.oddbit.com/2014/08/11/four-ways-to-connect-a-docker/

docker inspect --format '{{ .State.Pid }}' mailserver
15266

docker inspect --format '{{ .NetworkSettings.IPAddress }}' mailserver
172.17.0.44
```

# Shell
```
here=$(dirname $(readlink -f $0))
SCRIPTNAME=`basename $0`
extension="${SCRIPTNAME##*.}"
filename="${SCRIPTNAME%.*}"
```

### Trim 
```
Start sed -e 's/^[[:space:]]*//'
End sed -e 's/[[:space:]]*$//'
Both sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
... | sed -e 's/^ *//g' -e 's/ *$//g' -e 's/\"//g'
```

### Date
```
DATE=`date +%Y_%m_%d-%H_%M_%S`
echo `date +"%Y-%m-%d %T"`
=> 2016-04-16 22:44:06

currentDate=`date +%Y-%m-%d`
yesterdayDate=`date --date='1 days ago' +%Y%m%d`
if [[ "$ligne" == *\$currentDate* ]]; then
	...
elif [[ "$ligne" == *\$yesterdayDate* ]]; then
	...
	
date +"%s:%c"
1460839812:sam. 16 avril 2016 22:50:12 CEST	
```
### awk
```
cat <file> | grep <?> | awk -F'=' '{ print $2}'
echo awk -F ":" '{print "Nom : "$1}' /etc/passwd
```
### sed
```
sed -i "s/$OLD_IP/$DOCKER_IP/g" <file>
out=`echo $1 | sed -e "s|-raw.\(.*\)$|.\1|"`
... | sed -e 's/^ *//g' -e 's/ *$//g' -e 's/\"//g'
```

### Read
```
read -p "Please enter the hostname " host
echo "Regle à supprimer:"
read -p "[fail2ban-ssh 1] " rule
rule=${rule:-"fail2ban-ssh 1"}

while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
```

### cat
```
cat <<EOF >fichier
bla bla
...
bla bla
EOF
```

### case
```
[ -n "$1" ] && action=$1 || usage

	case $action in
		"install")
                        install
                ;;
		*)
		echo ""
		;;
	esac
```
### Détection de l'utilisateur
```
if [ $(whoami) = "root" ]
then
	echo You cannot run this script as root..
else
	echo You cannot run this script as root..
fi
```
### Boucles
```
for (( i=0; i<4;i++ ))
do
	echo $i
done

for i in {1..3}; do echo \$i; done

for i in `seq 1 5 20`
do
	echo $i
done

j=1
while [ $j -le 3 ]
do
	echo $j
	j=$(($j+1))
done

while (( h++ < 3 ))
do
	echo $h
done

while read; do
	echo $REPLY
done < <(find . -type f)

var=$(ls / | (
while read; do echo $REPLY; done
))

while read; do
	name=$(echo $REPLY|cut -d ":" -f1)
	echo "Nom : "$name
done < /etc/passwd

touch test1.csv
echo "aa;bb;cc" >> test1.csv
echo "a1;b1;c1" >> test1.csv
echo "aa;bb;cc"
echo "a1;b1;c1"

OLDIFS=$IFS
IFS=";"
while read status name path
do
	echo "status:$status-$path"
done < test1.csv
IFS=$OLDIFS
```
### Condition
```
var=OK
if [ "$var" = "OK" ]
then
	echo "OK"
elif [ "$var" = "KO" ]
then
	echo "KO"
else
	echo "..."
fi

if [ "$var" = "KO" ] || [ "$var2" = "KO" ]
then...

if [ "$var" = "KO" ] && [ "$var2" = "KO" ]
then....

if [ "$var3"="1" ] && [ "$var" = "KOI" ] || [ "$var3"="1" ] && [ "$var2" = "KO" ]; then
if [ "$var3"="1" -a \( "$var" = "KOI" -o  "$var2" = "KO" \) ]; then

if [ -z "$(rpm -qa )" ]
then
	echo "missing"
fi

[ "$var" = "OK" ] && echo "OK" || echo "KO"
```

### if grep
```
if grep -q $host /etc/hosts
then
  sed -i "s/$oldHost/$host/g" /etc/sysconfig/network
else 
  echo "$host not found in /etc/hosts"
fi

if [ $(grep -c string /path/to/file) -eq 0 ]...

#Tester si une chaine/sous-chaine est présente dans un fichier ou dans une chaine.

if [ $(echo "stringtest" | grep -c "test") -ne 0 ]
then
	echo "string exists"
else    
	echo "not exists"
fi

if [ $(grep -c "test" fileTest.txt) ]; then ....
```

### Calcul
```
i=$(($i+1))
```

### Comparaison d'entiers - nombres
```
[ $a -eq $b ] 	égalité entre a et b
[ $a -ne $b ] 	inégalité entre a et b
[ $a -ge $b ] 	supérioté ou égalité de a sur b
[ $a -gt $b ] 	supériorité stricte de a sur b
[ $a -le $b ]   infériorité stricte de a sur b
[ $a -lt $b ] 	infériorité ou égalité de a sur b
if (("$a" <= "$b")) infériorité ou égalité de a sur b
```
### Comparaison de chaine de caractères
```
[ -z STRING ]	STRING null (vide)
[ -n STRING ]   STRING non null (non vide)
[ STRING == STRING2 ] 	
[ STRING != STRING2 ] 	
[ STRING < STRING2 ] 	
[ STRING > STRING2 ]
```
 
### Teste sur les fichiers
```
[ -d FILE ] 	 FILE existe et est un répertoire.
[ -e FILE ] 	 FILE existe.
[ -f FILE ] 	 FILE existe et est un fichier classique (-rw-rw-rw- 1er tiret) "regular file"
[ -L or -h FILE ]FILE existe et est un lien symbolique
[ -r FILE ] 	 FILE existe et est en lecture
[ -s FILE ] 	 FILE existe et sa taille est supérieure à zéro
[ -w FILE ] 	 FILE existe et est en écriture
[ -x FILE ] 	 FILE existe et est exécutable
[ -O FILE ] 	 FILE existe et and appartient au user courant
[ -G FILE ] 	 FILE existe et and appartient au groupe courant
[ -N FILE ]      FILE existe et a été modifié depuis la dernière lecture
[ FILE1 -nt FILE2 ] FILE1 a été modifié plus récemment que FILE2, ou si FILE1 existe et FILE2 non
```
### Variables
```
VAR=`ls -a`
VAR=$(ls -a)

$# nombre d'args
$? code retour dernière commande.
```
### grep
```
echo "aaa uiii  zaza" | grep -w uiii

#Exclusion
echo "aaa uiii" | grep -v aa | grep ui

#Recherche multiple
grep -w 'warning\|error\|critical' test.txt

#Recherche expression régulière
echo "rereruui uiii aa" | grep -E "^re"

#Extraire IP d'un fichier
cat <file> | grep -Eo ‘([0-9]{1,3}\.){3}[0-9]{1,3}’ | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | uniq

#Compte
echo \"rereruui uiii aa\" | grep -c aa

#PID
pgrep -u user

# Lire fichier de config
PROPERTY = `grep "property" config.ini | cut -d =' -f2 | sed -e 's/^ *//g' -e 's/ *$//g' -e 's/\"//g'`
```

### lsof / fuser
```
# Afficher les processus ayant une activité réseau
lsof -Pnl +M -i4

# Fichier ouvert
lsof -u admin | grep | wc -l

# Process qui utilisent le fichier
fuser -uv <filename> 

# Process qui accèdent au path
fuser -uvm /home
```
 
### find
```
#Modifiés il y a moins de 24 heures
find . -mtime 0

#Modifiés il y a plus de 24 heures
find . -mtime +0

#Modifiés il y a moins de 10 minutes
find . -mmin -10

#Modifiés entre 24 heures et 48 heures
find . -mtime 1

#Modifiés il y a plus de 48 heures
find . -mtime +1

#Modifiés entre 1 et 2 minutes
find . -mmin +0 -mmin -2

#Permission données
find . -type f -perm -o=w

#grep -ir
find . -type f -print0 | xargs -0 -e grep -niH -e 'string'

#Supprimer les fichiers cachés
find -type f -name '.*' -exec rm {} \;

#Supprimer les répertoires vides
find . -type d -empty -print -exec rmdir -f {} \;

#Rechercher selon plusieurs motifs
find -type f \( -name "*.Ext1" -o -name "*.Ext2" \)

#Remplacer une chaine dans plusieurs fichiers
find ./ -type f -exec sed -i 's/OLD/NEW/' {} \;

#Boucler sur des fichiers/répertoires
find . -type d ! -name . -print | while read dir; do
...
done

#Afficher les x répertoires les plus lourds
find . -type d ! -name . -prune -exec du -sk {} \+ | sort -nr | tail -n 20

#Ignorer avec
-prune -o -print
```
### Array
```
ls | tee >( wc -l | { test=$(cat -) ; echo $test ; } ) | cat
aa
zz
..
10

test=$(find . )
echo ${test[@]}
aa
zz
..
echo ${#test[@]}
10
```

### tmux
```
tmux list-sessions / tmux ls : List session
tmux new -s sessionName : Create a new session with the name sessionName
tmux attach -t 0 : Attach the 0 session

Ctrl+b " - split pane horizontally.
Ctrl+b % - split pane vertically.
Ctrl+b arrow key - switch pane.
Hold Ctrl+b, don't release it and hold one of the arrow keys - resize pane.
Ctrl+b c - (c)reate a new window.
Ctrl+b n - move to the (n)ext window.
Ctrl+b p - move to the (p)revious window.

Ctrl+b d - Detach session
```

### rsync
```
EXCLUDE='--exclude '.DS_Store' --exclude '@eaDir' --exclude '.DS_Store@SynoResource' --exclude 'Thumbs.db' --exclude 'Thumbs.db@SynoResource''
rsync -phavz $EXCLUDE --bwlimit=$UP_LIMIT -e "ssh -p $SSH_PORT" $ARGS "$SSH_LOGIN@$SOURCE_SERVER:'$BACKUP_SRC'" $BACKUP_DEST
```

### Scripts Purge
```
NB_EXPORT=`ls -l ${path}/*.tar.gz 2>/dev/null | wc -l`
echo "nb export :"$NB_EXPORT "/" $NB_EXPORT_TO_KEEP | tee -a $LOG

if [ $NB_EXPORT -gt ${NB_EXPORT_TO_KEEP} ] ; then
	echo "Purge old export" | tee -a $LOG $LOG_TMP
	NB_EXPORT_RM=`expr $NB_EXPORT - $NB_EXPORT_TO_KEEP`
	echo "nb file to delete :"$NB_EXPORT_RM | tee -a $LOG $LOG_TMP
	FILE_TO_DELETE=`ls -lrta ${path}/*.tar.gz 2>/dev/null | sed -n "1,${NB_EXPORT_RM}p" | awk '{print $NF}'`
	echo "file to delete :"$FILE_TO_DELETE | tee -a $LOG $LOG_TMP
	rm -f $FILE_TO_DELETE | tee -a $LOG $LOG_TMP
else
	echo "No purge to do" | tee -a $LOG $LOG_TMP
fi
```

### init script
```
#!/bin/sh
#
# /etc/init.d/INIT: Start the NAME
#
### BEGIN INIT INFO
# Provides:	  NAME
# Required-Start: $local_fs $syslog $remote_fs
# Required-Stop: $remote_fs
# Default-Start:  2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start NAME
### END INIT INFO
NAME="<daemonName>"
PATH_BIN=/bin:/usr/bin:/sbin:/usr/sbin
DAEMON="/usr/bin/$NAME <options>"
DESC="Description"
RET=0

status(){
    pid=`pidof $NAME`
    if [ -z "$pid" ]; then
        RET=1
    else
        RET=0
    fi
    return $RET
}

case "$1" in
  start)
	status
	if [ "$?" = "0" ]; then
		echo "Already running"
		exit 1
	fi
	echo  "Starting $DESC" "$NAME" 
	$DAEMON 
	if [ $? = 0 ] ; then
            RET=0
        else
            RET=1
        fi
    ;;

  stop)
    echo "Stopping $DESC" "$NAME"
        status
        if [ "$?" = "1" ]; then
                echo "Already stopped"
                exit 1
        fi
   
    kill -9 `pgrep $NAME`
    ;;

  restart)
    stop
    sleep 2;
    start    
    ;;

  status)
        status
        if [ "$?" = "0" ]; then
                echo "$NAME running"
	else
		echo "$NAME not running"
        fi
    ;;
  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|restart|status}"
    RET=1
    ;;
esac
exit $RET
---------------------
update-rc.d <init script> defaults
```

### systemd
```
/usr/lib/systemd/system/
systemctl enable nom_du_service.service
systemctl disable nom_du_service.service
systemctl is-active nom_du_service.service
systemctl status nom_du_service.service
systemctl list-units --type=service 
systemctl start nom_du_service.service
systemctl stop nom_du_service.service
systemctl restart nom_du_service.service
systemctl reload nom_du_service.service
systemctl get-default : connaitre son niveau d'exécution
systemctl isolate nom.target
systemctl set-default nom.target

[Unit]
Description=Je dis ici à quoi sert le service
ConditionPathExists=/usr/sbin/commande
[Service]
Type=forking
ExecStart=/bin/sh -c 'commande'
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target

chmod a+x /etc/systemd/system/mon-service.service
systemctl --system daemon-reload

```

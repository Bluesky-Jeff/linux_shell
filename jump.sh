#!/bin/bash -
# Ops Server
# Author: ry
# Version: 0.0.1
# 
# 跳板机主脚本
# v1.0.0

. /etc/profile


### Config
DEFAULT_LOGIN_USER=ops

### System config, not change
ME=$(whoami)
CPWD=$(cd $(dirname $BASH_SOURCE); pwd -P)
#KEY_FILE=$CPWD/login_key
SERVER_CONFIG=$CPWD/server_list.conf


### INFO
clear
cat <<EOF
################################# 
### Ops Server.
#################################

EOF

### Walk
declare -a SERVER_LIST
echo_title=0
while read LOGIN_IP HOST_NAME LOGIN_USER; do
    if awk -v echo_index=$echo_title \
           'BEGIN { if (echo_index % 20 == 0) { exit 0; } else { exit 1; } }'; then
        echo '+--------------------------------------------------------------------------------+'
        printf "| %s | %-15s | %-39s | %-10s |\n" "Index" "Login IP" \
                                           "Host Name" "Login User"
        echo '+--------------------------------------------------------------------------------+'
    fi
    let echo_title++
    index=${#SERVER_LIST[@]}
    login_info="${LOGIN_USER:-$DEFAULT_LOGIN_USER}@${LOGIN_IP}"
    SERVER_LIST+=([$index]="$login_info")
    printf "|%6d | %-15s | %-39s | %-10s |\n" "$((index + 1))" "$LOGIN_IP" \
                         "$HOST_NAME" "${LOGIN_USER:-$DEFAULT_LOGIN_USER}"
done < <(grep -Ev '^#|^$' $SERVER_CONFIG)
echo '+--------------------------------------------------------------------------------+'

### Jump
echo
read -p "Input index:" choice
all_list_length=${#SERVER_LIST[@]}
if [ $choice -ge 0 -a $choice -le $all_list_length ] &> /dev/null; then
    LOGIN_SERVER=${SERVER_LIST[$((--choice))]}
    DATETIME="$(date "+%F %H:%M:%S")"

    echo "** [$ME] Login Server To: $LOGIN_SERVER ($DATETIME) **"
    logger -t sysAudit "[$ME] Login To $LOGIN_SERVER ($DATETIME)"

    # Login
    sudo -u ops /bin/ssh $LOGIN_SERVER

    DATETIME="$(date "+%F %H:%M:%S")"

    echo "** [$ME] Logout ($DATETIME)! **"
    logger -t sysAudit "[$ME] Logout From $LOGIN_SERVER ($DATETIME)"
else
    echo "[$choice] Index error." >&2
fi

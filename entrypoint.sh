#!/bin/sh

schedule=${BACKUP_SCHEDULE:-42 2 * * *}
prefix=${BACKUP_PREFIX:-backup-}
retains=${BACKUP_RETAIN_NUM:-3}
uid=${BACKUP_UID:-1000}
gid=${BACKUP_GID:-$uid}


backup_command="fname=\"/backup/${prefix}\$(date +%Y%m%d%H%M).tar.xz\" && cd /data && tar cJf \"\${fname}\" \$(ls -A) && chown \"${uid}:${gid}\" \"\${fname}\""

clean_command="ls \"/backup/${prefix}\"* | head -n \"-${retains}\" | xargs -r rm"
if [ "${retains}" -le 0 ]; then
    clean_command=":"
fi

if [ `grep -c " date ; fname=" /var/spool/cron/crontabs/root` -eq '0' ];then
    echo "${schedule} date ; ${backup_command} && ${clean_command}" >> /var/spool/cron/crontabs/root
fi

exec crond -f -L /dev/stdout

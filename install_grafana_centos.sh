#!/bin/bash



## Dependencias

yum -y install fontconfig
yum -y install freetype*
yum -y install urw-fonts
yum -y install https://dl.grafana.com/oss/release/grafana-6.7.2-1.x86_64.rpm


## Ativando o serviço

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server
systemctl status grafana-server




## Backup database

cat <<EOF > /etc/cron.daily/backup-grafana.sh
#!/bin/sh

#Debug
set +x

NOW=\`date +%y_%m_%d\`


tar -zcf /backup/grafana/grafana\${NOW}.tar.gz /var/lib/grafana/grafana.db
EXITVALUE=\$?
if [ \$EXITVALUE != 0 ]; then
    /usr/bin/logger -t GRAFANA "ALERT exited abnormally with \$EXITVALUE"
    exit \$EXITVALUE
fi


find /backup/grafana -mtime +30 -delete
EXITVALUE=\$?
if [ \$EXITVALUE != 0 ]; then
    /usr/bin/logger -t GRAFANA "ALERT exited abnormally with \$EXITVALUE"
    exit \$EXITVALUE
fi


exit 0


EOF





#Entrada de Informações
echo -n "Digite o nome do seu Hostname: "
read hostname
echo -n "Digite o gateway para conexão do Zabbix: "
read gateway
echo -n "Digite o endereço IP Zabbix Server: "
read server

#Instalação do Zabbix
yum install -y wget
wget https://repo.zabbix.com/zabbix/5.4/rhel/8/x86_64/zabbix-agent-5.4.7-1.el8.x86_64.rpm
rpm -i zabbix-agent-5.4.7-1.el8.x86_64.rpm
yum install -y zabbix-agent

#Configuração do Config do Zabbix
mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.original
echo "
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=20
Include=/etc/zabbix/zabbix_agentd.d/
#Hostname=$hostname
EnableRemoteCommands=1
LogRemoteCommands=1
Server=$server
ServerActive=$server
# UserParameter=
RefreshActiveChecks=120
ListenPort=10050
StartAgents=10
Timeout=30
DebugLevel=3
HostMetadataItem=system.uname
AllowKey=system.run[*]
" > /etc/zabbix/zabbix_agentd.conf

#Criação de Rota para o Zabbix
ip=10.24
iface=$( ip -o route get $ip | perl -nle 'if ( /dev\s+(\S+)/ ) {print $1}' )
echo "$server/32 via $gateway" >> /etc/sysconfig/network-scripts/route-$iface
ifdown $iface && ifup $iface

#Habilitação e Iniialização do Zabbix
systemctl start zabbix-agent
systemctl enable zabbix-agent

#Fim do Script
exit


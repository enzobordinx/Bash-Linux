#!/bin/bash
clear
#Echo function for success messages in green
success_echo() {
echo -e "\e[32m$1\e[0m"
}

#Echo function for warning messages in yellow
warning_echo() {
echo -e "\e[33m$1\e[0m"
}

#Echo function for error messages in red
error_echo() {
echo -e "\e[31m$1\e[0m"
}

#Create backupvsm directory in the home directory
if [ ! -d /home/backupvsm ]; then
sudo mkdir /home/backupvsm && success_echo "Diretório backupvsm criado com sucesso."
echo""
echo""

else
warning_echo "Diretório backupvsm já existe."
echo""
echo""

fi

#Navigate into the backupvsm directory
cd /home/backupvsm && success_echo "Entrando no diretório backupvsm."
echo""
echo""

#Download vsmInstallServidor.bash from the specified URL
if [ ! -f vsmInstallServidor.bash ]; then
sudo wget http://www.vsm.inf.br/downloads/installlinux/v7/vsmInstallServidor.bash && success_echo "Download do arquivo vsmInstallServidor.bash concluído."
echo""
echo""

else
warning_echo "O arquivo vsmInstallServidor.bash já existe."
echo""
echo""

fi

#Make vsmInstallServidor.bash executable
sudo chmod +x vsmInstallServidor.bash && success_echo "Permissões concedidas ao arquivo vsmInstallServidor.bash."
echo""
echo""

#Ask user if they want to run vsmInstallServidor.bash
read -p "Deseja executar o arquivo vsmInstallServidor.bash? [S/N]: " choice

if [[ $choice == [Ss] ]]; then

#Run vsmInstallServidor.bash
sudo ./vsmInstallServidor.bash && success_echo "Execução do arquivo vsmInstallServidor.bash concluída."
echo""
echo""

#Adicionar porta 3307 e reiniciar mysql
echo "port=3307" >> /etc/my.cnf
success_echo "Porta 3307 adicionada no MY.CNF"
echo""
echo""

../etc/init.d/mysql restar
warning_echo "Reiniciando MYSQL..."
echo""
echo""

echo -e "\e[32m[INFO]\e[39m Iniciando otimização do arquivo my.cnf para usar 60% da memória do sistema..."
echo ""
# Get total RAM in bytes
total_ram=$(grep MemTotal /proc/meminfo | awk '{print $2 * 1024}')
echo ""

# Calculate 60% of RAM
memory=$(echo "scale=0; $total_ram * 0.6 / 1024 / 1024" | bc)
echo""

# Get server ID
server_id=$(grep -oP "(?<=^server-id = )\d+" /etc/mysql/my.cnf)
echo""

# Determine max connections based on server ID
if [[ $server_id -eq 1 ]]; then
  max_connections=1200
else
  max_connections=900
fi

# Update my.cnf
sudo sed -i "s/^max_connections*$/max_connections = $max_connections/" /etc/mysql/my.cnf
sudo sed -i "s/^innodb_buffer_pool_size*$/innodb_buffer_pool_size = ${memory}M/" /etc/mysql/my.cnf

echo -e "\e[32m[INFO]\e[39m Configurações realizadas com sucesso:"
echo -e "\e[32m[INFO]\e[39m   - max_connections definido como $max_connections"
echo -e "\e[32m[INFO]\e[39m   - innodb_buffer_pool_size definido como ${memory}M"
echo -e "\e[32m[INFO]\e[39m Reiniciando o serviço MySQL..."

# Restart MySQL service
sudo service mysql restart
echo""
echo""
echo -e "\e[32m[INFO]\e[39m Serviço MySQL reiniciado com sucesso!"

else
warning_echo "Execução do arquivo vsmInstallServidor.bash cancelada pelo usuário."
echo""
echo""

fi

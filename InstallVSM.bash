#!/bin/bash

clear
LINUX_VERSION=$(cat /etc/issue | awk '{print $2}')
sudo apt install figlet
figlet $LINUX_VERSION
figlet ENZO XAVIER
echo""
echo""
sleep 2


function progressBar {
    local duration=${1}

    # Variables for the progress bar
    local block="▓"
    local empty="░"
    local totalBlocks=10
    local progress=0
    local currentBlock=0
    local percent=0
    local sleepDuration=$(echo "scale=2; $duration/$totalBlocks" | bc)


    # Loop through the progress bar
    while [ $progress -lt $totalBlocks ]; do
        # Calculate the current percentage
        percent=$(( $progress * 10 ))

        # Print the progress bar
        printf "\r${block:0:$currentBlock}${empty:0:$((totalBlocks-currentBlock))} ${percent}%%"

        # Update the progress variables
        ((progress++))
        ((currentBlock++))

        # Wait for a short duration
        sleep $sleepDuration
    done

    # Print the final progress bar with 100% completion
    printf "\r${block:0:$totalBlocks}${empty:0:0} 100%%\n"
}

# Call the progress bar function with a duration
progressBar 1
echo""
echo""
clear


# Checks if the user already has an MYSQL
function check_mysql {
    echo "Checando se o servidor possui processo do MYSQL e pasta..."

    # Check for MySQL process
    if pgrep -x "mysqld" >/dev/null; then
        echo -e "\033[0;31mMySQL Serviço encontrado.\033[0m"
		echo ""
		echo ""
        exit 1
    fi

    # Check for MySQL folder
    if [ -d "/usr/local/mysql" ]; then
        echo -e "\033[0;31mMySQL pasta encontrada.\033[0m"
		echo ""
		echo ""
        exit 1
    fi

    # If MySQL process and folder not found
    echo -e "\033[0;32mServiço MySQL e pasta não encontrado.\033[0m"
}

check_mysql
echo ""
echo ""

 #!/bin/bash

LINUX_INFO=$(cat /etc/issue)
LINUX_VERSION=$(echo $LINUX_INFO | awk '{print $1}')
UBUNTU_VERSION=$(echo $LINUX_INFO | awk '{print $2}')

echo -e "Versão do Linux: ${LINUX_VERSION} ${UBUNTU_VERSION}"

if [[ $LINUX_VERSION == "Ubuntu" ]]; then
    if [[ $(echo $UBUNTU_VERSION | awk -F. '{ printf "%02d%02d", $1,$2 }') -ge 1804 ]]; then
        echo -e "Linux está no recomendado."

        read -p "Deseja instalar o pacote libncurses5? (y/n) " choice
        case "$choice" in
            y|Y )
                echo -e "Instalando libncurses5... [WAIT]"
                echo ""
                echo ""
                sudo apt install libncurses5 -y
                echo ""
                echo ""
                echo -e "Instalado"
                echo -e "\033[32m[OK]\033[0m"
                echo ""
                echo ""
                ;;
            n|N ) ;;
            * ) echo -e "Opção inválida. O pacote libncurses5 não será instalado.";;
        esac
    else
        echo -e "Versão do Linux fora do padrão. Por favor, instale Ubuntu 18.04 LTS or higher."
        echo -e "Versão do LINUX: \033[31m[FAIL]\033[0m"
    fi
else
    echo -e "Este script é apenas para o Ubuntu."
fi



# Validate Linux architecture
LINUX_ARCH=$(uname -m)
if [[ $LINUX_ARCH != "x86_64" ]]; then
  echo -e "Arquitetura: ${LINUX_ARCH}"
  echo -e "Arquitetura: \033[31m[FAIL]\033[0m"
  echo "Arquitetura do linux incorreta. Please install a 64-bit version of Ubuntu."
  echo ""
else
  echo -e "Arquitetura: ${LINUX_ARCH}"
  echo -e "Arquitetura: \033[32m[OK]\033[0m"
  echo "Arquitetura do linux esta dentro do padrao."
  echo ""
fi

# Validate RAM
#LINUX_RAM=$(free -m | awk 'NR==2{print $2}')
#if [[ $LINUX_RAM -lt 4000 ]]; then
#  echo "RAM fora do padrao. Minimum required is 4GB."

#echo -e "RAM: ${LINUX_RAM}MB"
#echo -e "RAM: \033[31m[FAIL]\033[0m"
#  echo ""
#  echo ""

#else
#  echo "RAM esta dentro do padrao, Maior que 4GB."

#echo -e "RAM: ${LINUX_RAM}MB"
#echo -e "RAM: \033[32m[OK]\033[0m"

#echo ""
#echo ""

#fi


# Validate RAM
LINUX_RAM=$(free -m | awk 'NR==2{print $2}')

if [[ $LINUX_RAM -lt 4000 ]]; then
  echo "RAM nao atingiu o minimo para um local server."
  echo -e "RAM: ${LINUX_RAM}MB"
  echo -e "Status: \033[31m[FAIL]\033[0m"
echo""
echo""
else
  if [[ $LINUX_RAM -lt 6000 ]]; then
    echo "RAM atinge o minimo de 4GB para um local server."
    echo -e "RAM: ${LINUX_RAM}MB"
    echo -e "Status: \033[32m[OK]\033[0m"
echo""
echo""
  else
    echo "RAM atinge o minimo de 6GB ou mais para um central server."
    echo -e "RAM: ${LINUX_RAM}MB"
    echo -e "Status: \033[32m[OK]\033[0m"
echo""
echo""

  fi
fi




#!/bin/bash

# Validate if it's HD or SSD
LINUX_STORAGE=$(cat /sys/block/sda/queue/rotational)
if [[ $LINUX_STORAGE -eq 0 ]]; then
  echo -e "Status: \033[32m[OK]\033[0m"
  echo "DISCO: ${LINUX_STORAGE}"
  echo "O disco e SSD."
  echo ""
else
  echo -e "Status: \033[33m[LENTO]\033[0m"
  echo "DISCO: ${LINUX_STORAGE}"
  echo "O disco e HD."
  echo ""
fi

# Ask user for backup size
read -p "Qual é o tamanho do backup em GB? " backup_size

# Calculate required free space
required_space=$(echo "$backup_size * 2.4" | bc)
required_space="${required_space%.*}" # Round down to nearest integer

# Check if storage has enough free space
echo "Validating disk space"
free_space=$(df -h / | awk '/^\/dev/{print $4}')
if [[ $(echo $free_space | cut -d'G' -f1) -ge $required_space ]]; then
    echo "Free space: ${free_space}"
    echo -e "Disk: [\033[0;32mOK\033[0m]"
else
    echo "Free space: ${free_space} (minimum requirement: ${required_space}GB)"
    echo -e "Disk: [\033[0;31mFAIL\033[0m]"
fi
echo ""
echo ""

# Prompt user to update and upgrade
read -p "Deseja rodar o upgrade no linux? (Y/N) " choice
case "$choice" in
  y|Y ) sudo apt-get update && sudo apt-get upgrade -y;;
  n|N ) echo -e "\033[33mPulando UPDATE & UPGRADE\033[0m";;
  * ) echo "[Invalid choice.] Pulando update and upgrade.";;
esac

clear

# Echo function for success messages in green
success_echo() {
  echo -e "\e[32m$1\e[0m"
}

# Echo function for warning messages in yellow
warning_echo() {
  echo -e "\e[33m$1\e[0m"
}

# Echo function for error messages in red
error_echo() {
  echo -e "\e[31m$1\e[0m"
}

clear

free_space=$(df -h / | awk '/^\/dev/{print $4}')
figlet DISCO LIVRE: $free_space
figlet VSM
echo ""
echo ""
sleep 2

# Flash progressBar
progressBar 2
clear




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

#!/bin/bash

# Functions to improve readability
success_echo() {
  echo -e "\033[32m$1\033[0m"
}

warning_echo() {
  echo -e "\033[33m$1\033[0m"
}

# Make vsmInstallServidor.bash executable
sudo chmod +x vsmInstallServidor.bash
success_echo "Permissões concedidas ao arquivo vsmInstallServidor.bash."
echo ""
echo ""

# Ask user if they want to run vsmInstallServidor.bash
read -p "Deseja executar o arquivo vsmInstallServidor.bash? [S/N]: " choice

if [[ $choice == [Ss] ]]; then
  # Run vsmInstallServidor.bash
  sudo ./vsmInstallServidor.bash
  success_echo "Execução do arquivo vsmInstallServidor.bash concluída."
  echo ""
  echo ""

  # Add port 3307 and restart MySQL
  echo "port=3307" | sudo tee -a /etc/my.cnf
  success_echo "Porta 3307 adicionada no MY.CNF"
  echo ""
  echo ""

  warning_echo "Reiniciando MYSQL..."
  echo ""
  echo ""

  echo -e "\033[32m[INFO]\033[39m Iniciando otimização do arquivo my.cnf para usar 60% da memória do sistema..."
  echo ""

  # Get total RAM in bytes
  total_ram=$(grep MemTotal /proc/meminfo | awk '{print $2 * 1024}')
  echo ""

  # Calculate 60% of RAM
  memory=$(echo "scale=0; $total_ram * 0.6 / 1024 / 1024" | bc)
  echo ""

  # Get server ID
  server_id=$(grep -oP "(?<=^server-id = )\d+" /etc/my.cnf)
  echo ""

  # Determine max connections based on server ID
  if [[ $server_id -eq 1 ]]; then
    max_connections=1200
  else
    max_connections=900
  fi

  # Update my.cnf
  sudo sed -i "s/^max_connections.*$/max_connections = $max_connections/" /etc/my.cnf
  sudo sed -i "s/^innodb_buffer_pool_size.*$/innodb_buffer_pool_size = ${memory}M/" /etc/my.cnf

  echo -e "\033[32m[INFO]\033[39m Configurações realizadas com sucesso:"
  echo -e "\033[32m[INFO]\033[39m   - max_connections definido como $max_connections"
  echo -e "\033[32m[INFO]\033[39m   - innodb_buffer_pool_size definido como ${memory}M"
  echo -e "\033[32m[INFO]\033[39m Reiniciando o serviço MySQL..."

  # Restart MySQL service
  sudo service mysql restart
  echo ""
  echo ""
  echo -e "\033[32m[INFO]\033[39m Serviço MySQL reiniciado com sucesso!"

else
  warning_echo "Execução do arquivo vsmInstallServidor.bash cancelada pelo usuário."
  echo ""
  echo ""
fi


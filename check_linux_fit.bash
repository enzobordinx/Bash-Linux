#!/bin/bash


clear

echo"'_________________________         _____'"
echo"' \_   _____/\______   \   \      /  _  \'"
echo"'  |    __)_  |       _/   /     /  /_\  \'"
echo"'  |        \ |    |   \  /     /    |    \'"
echo"' /_______  / |____|_  / /_____/____|__  /'"
echo"'         \/         \/              \/ ENZO VSM'"
echo""

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

# Call the progress bar function with a duration of 4 seconds
progressBar 1
echo""
echo""
clear

# Validate Linux version
LINUX_VERSION=$(cat /etc/issue | awk '{print $2}')
if [[ $LINUX_VERSION == "Ubuntu" && ($(cat /etc/issue | awk '{print $3}') =~ ^(18\.04|20\.04|20\.10|21\.04)$) ]]; then
  echo -e "Linux está no recomendado."

echo -e "$Versao do linux: ${LINUX_VERSION}"
echo -e "${LINUX_VERSION} \033[32m[OK]\033[0m"

  echo ""
  echo ""
  if [[ $LINUX_VERSION == "Ubuntu" && ($(cat /etc/issue | awk '{print $3}') =~ ^(20\.04|20\.10|21\.04)$) ]]; then
    echo -e "Instalando libncurses5... [WAIT]"
    echo ""
    echo ""

    sudo apt install libncurses5
    echo -e "Instalado"
    echo -e "\033[32m[OK]\033[0m"
    echo ""

  fi
else
  echo -e "Versão do linux fora do padrao. Por favor, instale Ubuntu 18.04 LTS or higher."

echo -e "$Versao LINUX: ${LINUX_VERSION}"
echo -e "$Versao LINUX: \033[31m[FAIL]\033[0m"
  echo ""
  echo ""

fi

# Validate Linux architecture
LINUX_ARCH=$(uname -m)
if [[ $LINUX_ARCH != "x86_64" ]]; then
  echo "Arquitetura do linux incorreta. Please install a 64-bit version of Ubuntu."

echo -e "Arquitetura: ${LINUX_ARCH}"
echo -e "Arquitetura: \033[31m[FAIL]\033[0m"

  echo ""
  echo ""

else
  echo "Arquitetura do linux esta dentro do padrao."

echo -e "Arquitetura: ${LINUX_ARCH}"
echo -e "Arquitetura: \033[32m[OK]\033[0m"

 echo ""
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




# Validate if it's HD or SSD
LINUX_STORAGE=$(cat /sys/block/sda/queue/rotational)
if [[ $LINUX_STORAGE -eq 0 ]]; then
  echo "O disco e SSD."
echo -e "\033[32m[OK]\033[0m"
echo ""
echo ""

else
  echo "O disco e HD."
echo -e "\033[33m[LENTO]\033[0m"
echo ""
echo ""

fi

# Check if storage has at least 100GB free space
echo "Validando espaco em disco"
free_space=$(df -h / | awk '/^\/dev/{print $4}')
if [[ $(echo $free_space | cut -d'G' -f1) -ge 100 ]]; then

    echo "Livre: ${free_space}"
    echo -e "Disco: [\033[0;32mOK\033[0m]"

else

    echo "Livre: ${free_space} (minimum requirement: 100GB)"
    echo -e "Disco: [\033[0;31mFAIL\033[0m]"

echo ""
echo ""
fi

# Prompt user to update and upgrade
read -p "Deseja rodar o upgrade no linux? (Y/N) " choice
case "$choice" in
  y|Y ) sudo apt-get update && sudo apt-get upgrade;;
  n|N ) echo -e "\033[33mPulando UPDATE & UPGRADE\033[0m";;
  * ) echo "[Invalid choice.] Pulando  update and upgrade.";;
esac


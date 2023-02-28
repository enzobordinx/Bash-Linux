 _______  _______  _______  _______  _______  _______  _______  _______ 
|       ||       ||   _   ||       ||       ||       ||       ||       |
|  _____||    ___||  |_|  ||_     _||  _____||_     _||    ___||_     _|
| |_____ |   |___ |       |  |   |  | |_____   |   |  |   |___   |   |  
|_____  ||    ___||       |  |   |  |_____  |  |   |  |    ___|  |   |  
 _____| ||   |___ |   _   |  |   |   _____| |  |   |  |   |___   |   |  
|_______||_______||__| |__|  |___|  |_______|  |___|  |_______|  |___|  



# Bash-Linux
This repository contains two Bash scripts. The first one is used to check if the Linux system meets the minimum requirements for installation. The second one automates the installation process. These scripts are designed to make it easier to install software on Linux systems. They are user-friendly and can save you time by automating the process.


Linux Installation Scripts
This repository contains two Bash scripts to help with Linux installation:

check_linux_fit.sh: This script checks if the current Linux system meets the minimum hardware requirements for installation.

automate_linux_install.sh: This script automates the installation process of a Linux system on a target device.

check_linux_fit.sh
This script checks the amount of RAM in the system and ensures it meets the minimum requirement of 4GB. If the RAM is less than 4GB, the script will print an error message and exit with an error code. If the RAM is 4GB or more, the script will print a success message and exit with a success code.

automate_linux_install.sh
This script automates the installation process of a Linux system on a target device. The script prompts the user to enter the device's name and type of Linux to install. It then downloads the required files and installs the Linux system on the target device.

Note: This script assumes that the target device is already prepared with the required partitioning.

Usage
To use the script, simply run it with the following command:

bash
Copy code
./automate_linux_install.sh
The script will guide you through the installation process and prompt you for any required inputs.

License
This project is licensed under the MIT License. Feel free to use and modify the code as per your requirements.

#!/bin/bash

# Function to log ansible setup errors
log_error() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >>/var/log/init_environment_setup_errors.log
}

# Function to install packages with error handling
install_package() {
  local package_name=$1
  shift
  echo "$(date '+%Y-%m-%d %H:%M:%S'): Installing $package_name..."
  sudo "$@" # Run the command with sudo

  if [[ $? -ne 0 ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $package_name installation failed with error code $?."
    exit 1
  else
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $package_name installed successfully."
  fi
}

# Function to install Ansible based on the Linux distribution
# Function to install Ansible based on the Linux distribution
install_ansible() {
  if ! command -v ansible &>/dev/null; then
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Ansible is not installed. Installing Ansible..."

    if [ -x "$(command -v dnf)" ]; then  # Fedora, Red Hat, CentOS, AlmaLinux
      install_package 'Python3 and pip' dnf install -y python3-pip
      install_package 'Ansible' python3 -m pip install ansible || install_package 'Ansible' dnf install -y ansible
      
      
    elif [ -x "$(command -v yum)" ]; then  # Older versions of Red Hat, CentOS
      if grep -q 'release 6' /etc/redhat-release; then
        install_package 'epel-release' yum install -y epel-release || log_error "epel-release installation failed."
        install_package 'Ansible'  yum install -y ansible || log_error "Ansible installation failed."
      elif grep -q 'release 7' /etc/redhat-release; then
        install_package yum install -y ansible || log_error "Ansible installation failed."
      else
        echo "$(date '+%Y-%m-%d %H:%M:%S'): Unsupported Red Hat-based distribution. Cannot install Ansible."
      fi
    elif [ -x "$(command -v apt-get)" ]; then  
      # Debian, Ubuntu
      if lsb_release -d | grep -q 'Ubuntu 23.04'; then
        if ! command -v pip &>/dev/null || ! command -v pipx &>/dev/null; then
          install_package apt update
          install_package apt install -y python3-pip || log_error "Pip installation failed."
          install_package pip install pipx || log_error "Pipx installation failed."
        fi
        
        pipx ensurepath
      elif lsb_release -d | grep -q 'Ubuntu'; then
        if ! command -v pip &>/dev/null || ! command -v pipx &>/dev/null; then
          install_package apt-get update
          install_package apt-get install -y python3-pip || log_error "Pip installation failed."
          install_package pip install pipx || log_error "Pipx installation failed."
        fi
        
        pipx ensurepath
      else
        install_package apt-get update
        install_package apt-get install -y ansible || log_error "Ansible installation failed."
        pipx ensurepath
      fi
    else
      echo "$(date '+%Y-%m-%d %H:%M:%S'): Unsupported distribution. Cannot install Ansible."
    fi
  else
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Ansible is already installed."
  fi
}

# Check if the user 'ansible' exists and add if not present
if ! id "ansible" >/dev/null 2>&1; then
  echo "Adding user 'ansible'"
  sudo useradd -m ansible
  echo "ansible:ansible" | sudo chpasswd
  sudo usermod -aG wheel ansible

  if id "ansible" >/dev/null 2>&1; then
    echo "User 'ansible' has been added."
    echo "ansible:ansible" | sudo chpasswd
    sudo usermod -aG wheel ansible
    sudo visudo -c -f /etc/sudoers.d/ansible && echo 'ansible ALL=(ALL:ALL) NOPASSWD:ALL' >/etc/sudoers.d/ansible || log_error "Sudoers configuration failed."
  else
    echo "Problem occurred while adding the user 'ansible'. Error code: $?"
  fi
else
  echo "User 'ansible' already exists."
fi

# Check hostname and install Ansible if the hostname is 'controller.lab.com'
if [ "$(hostname)" = "controller.lab.com" ]; then
  # Call the function to install Ansible
  install_ansible
fi

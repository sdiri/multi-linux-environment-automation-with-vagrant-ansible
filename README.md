MIT License

# Environment Setup Script

## Overview
This Bash script is designed for setting up environments across multiple Linux machines using Vagrant and Ansible. The script automates the setup process, including the installation of necessary packages, user creation, SSH key acceptance, and more.

## Features
- **User Management:** Creates the 'ansible' user with sudo privileges and adds it to the 'wheel' group.
- **Package Installation:** Installs required packages such as Python3, pip, and Ansible based on the Linux distribution.
- **Hostname Check:** Installs Ansible specifically on the 'controller.lab.com' machine.
- **SSH Configuration:** Accepts SSH keys for all provisioned machines to facilitate Ansible communication.

## Functions
### log_error()
- Logs errors encountered during the Ansible setup process into `/var/log/init_environment_setup_errors.log`.

### install_package()
- Installs packages and handles installation errors gracefully.

### install_ansible()
- Installs Ansible based on the Linux distribution detected on the machine.

### Main Execution
1. Checks if the 'ansible' user exists and adds it if not present.
2. Executes the Ansible setup script specifically on 'controller.lab.com'.
3. Configures the 'known_hosts' file for SSH keys on each machine.

## Usage
The script is intended to be used within a Vagrant environment for automatic setup and provisioning of multiple Linux machines. It requires minimal user intervention once initiated.

## Notes
- This script assumes familiarity with Vagrant, Bash scripting, and Linux system administration.
- Users are advised to review the script and modify it according to specific requirements before usage.


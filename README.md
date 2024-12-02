# WSL Development Environment Setup

This repository contains scripts to automate the setup of a development environment in Windows Subsystem for Linux (WSL). The setup includes various tools and configurations commonly used in development workflows.

## Features
- Automated WSL installation
- ZSH shell with custom configuration
- Starship prompt with custom theme
- FZF (Command-line fuzzy finder)
- ZSH autosuggestions
- Various development tool configurations (Kubernetes, Docker, Python, Node.js, etc.)
- Automatic sudo privileges configuration

## Prerequisites
- Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 11
- Administrator access on your Windows machine
- PowerShell access

## Installation Steps

### 1. Install WSL
1. Open PowerShell as Administrator
2. Run the installation script:   ```powershell
   .\install_wsl.ps1   ```
3. Restart your computer when prompted

### 2. Configure WSL Environment
1. Open Ubuntu WSL
2. Clone this repository:   ```bash
   git clone <repository-url>
   cd new-setup-configurations   ```
3. Make the setup script executable and run it:   ```bash
   chmod +x setup_wsl.sh
   ./setup_wsl.sh   ```
**Note**: If the script fails to set sudo privileges, manually replace `$USER` in the script with your actual username.

## What Gets Installed
- **ZSH**: Modern shell with enhanced features
- **Starship**: Cross-shell prompt with Git status integration, Python environment detection, Node.js version display, Kubernetes context, Docker context, and more
- **FZF**: Command-line fuzzy finder
- **ZSH Autosuggestions**: Fish-like autosuggestions for ZSH

## Configuration Details
### Starship Configuration
The setup includes a comprehensive Starship configuration with support for:
- Multiple programming languages (Python, Node.js, etc.)
- Container tools (Docker, Kubernetes)
- Infrastructure tools (Terraform, Helm)
- Git information
- System status

### ZSH Configuration
The ZSH configuration includes:
- Command history sharing between sessions
- Kubectl alias (k)
- FZF integration
- Kubectl auto-completion
- Google Cloud SDK integration (if installed)

## Customization
You can customize the setup by modifying:
- `~/.config/starship.toml` for Starship prompt settings
- `~/.zshrc` for ZSH configurations
- `setup_wsl.sh` for installation preferences

## Troubleshooting
1. **Sudo Privileges**: If the automatic sudo configuration fails:   ```bash
   sudo visudo   ```
   Then manually add: `your_username ALL=(ALL) NOPASSWD: ALL`

2. **Shell Not Changing**: If ZSH doesn't become your default shell:   ```bash
   chsh -s $(which zsh)   ```

## Contributing
Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## License
MIT License - Feel free to use this code for your own projects.
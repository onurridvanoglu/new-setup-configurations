# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator"
    exit 1
}

# Install WSL
Write-Host "Installing WSL with Ubuntu..."
wsl --install -d Ubuntu

Write-Host "WSL installation complete. Please restart your computer and then run the setup_wsl.sh script inside Ubuntu." 
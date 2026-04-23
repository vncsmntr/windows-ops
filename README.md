# 🛠️ Windows Ops Toolkit

A professional collection of PowerShell scripts for Windows administration, focused on system health, initial provisioning, and automation.

## 🚀 Quick Execution

Run any script directly from PowerShell (Admin):

`irm "https://raw.githubusercontent.com/vncsmntr/windows-ops/main/[folder]/[script].ps1" | iex`

## 📂 Project Structure

* **`maintenance/`**: System repairs and health checks.
    * `healthcheck.ps1`: Automated DISM, SFC, and Chkdsk guardian.
* **`setup/`**: Environment provisioning.
    * `game-setup.ps1`: Dynamic game library folder creator (Steam, Epic, etc).
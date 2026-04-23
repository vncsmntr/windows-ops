# 📂 Setup & Provisioning Scripts

Scripts dedicated to the initial configuration of a fresh Windows install or new hardware. Focuses on organization and automation of repetitive setup tasks.

### 🎮 Game Library Setup

Dynamically creates a clean directory structure for all major game launchers (Steam, Epic, GOG, etc.) on a target drive of your choice.

**Quick Run:**

```powershell
irm "https://raw.githubusercontent.com/vncsmntr/windows-ops/main/setup/game-setup.ps1" | iex
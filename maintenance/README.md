# 📂 Maintenance Scripts

Focuses on system integrity, stability, and emergency recovery. These tools ensure your Windows installation remains healthy after crashes or power failures.

### 🛡️ System Health Guardian

Automates the repair of Windows Image (DISM), System Files (SFC), and schedules Disk Checks (Chkdsk) in the most efficient order.

**Quick Run:**

```powershell
irm "https://raw.githubusercontent.com/vncsmntr/windows-ops/main/maintenance/healthcheck.ps1" | iex
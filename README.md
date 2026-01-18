# Bash Workplace Check
A collection of Bash scripts for automated Linux workstation and server health monitoring.

## 📁 Project Structure

- **desktop/**: Scripts for monitoring user desktop clutter and space.
- **system/**: Core system health (Disk, Memory, Uptime).
- **user/**: User-specific checks (Sessions, Home size, History).
- **network/**: Basic connectivity and DNS audits.
- **server/**: Security and service status checks.
- **lib/**: Shared functions and utilities.

## 🚀 How to use
Each script can be run independently. Ensure they have execution permissions.
```bash
chmod +x **/*.sh
./system/check_disk_usage.sh
```

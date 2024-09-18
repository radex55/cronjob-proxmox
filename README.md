# cronjob-proxmox
Bash code to overcome the problem of charging old laptop batteries (not supporting TLP) that have Proxmox installed with a smart wireless switch device (Tuya).

# create file : switch_on.sh (start charging device)
- open terminal/ssh to proxmox :
- nano /home/switch_on.sh
- paste code from switch_on.sh
- change value : 
  1. DeviceID
  2. ClientID
  3. ClientSecret
  4. BaseUrl (Opsional, case : when device not region: Western America Data Center)
- then save with : ctrl + X -> Yes
- change permission can execute : chmod +x /home/switch_on.sh

# create file : switch_off.sh (stop charging device)
- open terminal/ssh to proxmox :
- nano /home/switch_off.sh
- paste code from switch_off.sh
- change value : 
  1. DeviceID
  2. ClientID
  3. ClientSecret
  4. BaseUrl (Opsional, case : when device not region: Western America Data Center)
- then save with : ctrl + X -> Yes
- change permission can execute : chmod +x /home/switch_off.sh

# create file cron : check_battery.sh (check battery percentage condition)
- open terminal/ssh to proxmox :
- nano /home/check_battery.sh
- paste code from check_battery.sh
- change value : 
  1. CHARGER_STATUS (adjust what is read on your device)
  2. BATTERY_CAPACITY (adjust what is read on your device)
- then save with : ctrl + X -> Yes
- change permission can execute : chmod +x /home/check_battery.sh

# create file cron : cron_script.sh (if the power is reconnected and matches the conditions on the battery percentage check_battery.sh)
- open terminal/ssh to proxmox :
- nano /home/cron_script.sh
- paste code from cron_script.sh
- change value : 
  1. CHARGER_STATUS (adjust what is read on your device)
- then save with : ctrl + X -> Yes
- change permission can execute : chmod +x /home/cron_script.sh

# create file cron : shutdown_if_battery_low.sh (if the power is not reconnected and according to the conditions on the battery percentage check_battery.sh)
- open terminal/ssh to proxmox :
- nano /home/shutdown_if_battery_low.sh
- paste code from shutdown_if_battery_low.sh
- change value : 
  1. BATTERY_CAPACITY (adjust what is read on your device)
- then save with : ctrl + X -> Yes
- change permission can execute : chmod +x /home/shutdown_if_battery_low.sh

# add to cronjob
- open terminal/ssh to proxmox :
- paste this : (crontab -l 2>/dev/null; echo "* * * * * /home/check_battery.sh") | crontab -

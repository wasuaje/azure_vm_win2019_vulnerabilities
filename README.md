# Playbook Windows 20190 Server Security Center Vulnerabilities Fix

## Directions:
Set the target variable, it points to the proxy ansible server (where you install az cli, terraform, etc.)
```
target: myserver.mydomain.com
```

If you run the playbook locally or through Tower/AWS nothing to change

## Usage:
1) Checkout the project locally
2) Create a new powershell script at vm-automation folder with this format MMYYYY-SHORTDESCRIPTION.ps1, like: 062021-registry-fix.ps1
3) Push that changes, once merged change the next variable with your PS script name, 
4) Run.....Enjoy
   
```
var_automation_id: "062021-registry-fix-2.ps1"
var_restart_vm: true #If you want VM restarted afterwards
```
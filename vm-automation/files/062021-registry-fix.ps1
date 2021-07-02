
#
# 105228-Built-in Guest Account Not Renamed at Windows Target System
#
$oldName = "guest"
$newName = "oats-guest-user"
$user = Get-WMIObject Win32_UserAccount -Filter "Name='$oldName'"
try {
  $result = $user.Rename($newName)
}
catch {
  Write-Output "Couldn´t rename user or user already renamed"
}

if ($result.ReturnValue -eq 0) {
  Write-Output "Guest account succesfuly renamed"
}

#
#90007-Enabled Cached Logon Credential
#

$path = "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
#Get-ItemProperty -Path $path -Name CachedLogonsCount
Set-ItemProperty -Path $path -Name CachedLogonsCount -Value 0
Write-Output "Enabled Cached Logon Credential succesfully set to 0"

#
# 105170-Microsoft Windows Explorer AutoPlay Not Disabled
#

$path = "Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
# Get-ChildItem -Path $path
$key = "NoDriveTypeAutoRun"
try { 
    Get-ItemProperty -Path $path -Name $key    
}catch [System.Management.Automation.PSArgumentException] {
  Write-Output "NoDriveTypeAutoRun doesn´t exist at Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, creating"    
      }
try {
  Set-ItemProperty -Path $path -Name $key -Value 255
}catch{
  Write-Output "Coudln´t create NoDriveTypeAutoRun at Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
}

Write-Output "Microsoft Windows Explorer AutoPlay set to Disabled"

#
#90044-Allowed Null Session
#
$path = "Registry::HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$path2 = "Registry::HKLM\SYSTEM\CurrentControlSet\Control\LSA"
$key = "RestrictNullSessAccess"
# Get-ItemProperty -Path $path -Name $key
Set-ItemProperty -Path $path -Name $key -Value 1
Write-Output "Allowed Null Session set to 1 (disabled)"

$key = "RestrictAnonymous"
# Get-ItemProperty -Path $path -Name $key
Set-ItemProperty -Path $path -Name $key -Value 1
Set-ItemProperty -Path $path2 -Name $key -Value 1
Write-Output "RestrictAnonymous Session set to 1 (disabled)"

#
#105171-Windows Explorer Autoplay Not Disabled for Default User
#
$path_prev = "Registry::HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies"
$path = "Registry::HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$key = "NoDriveTypeAutoRun"
# Need to create this first as usually it's not in there beforehand
New-Item -Path $path_prev
New-Item -Path $path 
# Get-ItemProperty -Path $path -Name $key
Set-ItemProperty -Path $path -Name $key -Value 1
Write-Output "Windows Explorer Autoplay for current user disabled"

#
#90043-SMB Signing Disabled or SMB Signing Not Required
#

$path = "Registry::HKLM\System\CurrentControlSet\Services\LanManServer\Parameters"
$key1 = "RequireSecuritySignature"
$key2 = "EnableSecuritySignature"
Set-ItemProperty -Path $path -Name $key1 -Value 1
Set-ItemProperty -Path $path -Name $key2 -Value 1

$path = "Registry::HKLM\System\CurrentControlSet\Services\LanmanWorkStation\Parameters"
New-Item -Path "Registry::HKLM\System\CurrentControlSet\Services\LanmanWorkStation"
New-Item -Path $path
Set-ItemProperty -Path $path -Name $key1 -Value 1
Set-ItemProperty -Path $path -Name $key2 -Value 1

Write-Output "Signing Disabled or SMB Signing Not Required"

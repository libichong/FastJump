# FastJump
` fast jump in powershell and fast edit file with your farvorate editor
#. install it: Import-Module .\Invoke-FastJump.psm1 -Force -DisableNameChecking
##. Set-Clipboard only supports in Powershell 5.0 above
##. PSScriptRoot only exists in Powershell 2.0 above
##. Better installtion solution:
###. Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm
###. New-item ¨Ctype file ¨Cforce $profile
###. Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

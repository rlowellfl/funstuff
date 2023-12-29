########
# Info
########

# This script will compare your Deep Rock Galactic save files between Steam and Xbox PC versions, and will overwrite the older one with the newer.
# This allows you to keep your progress when switching between different versions of the game.
# Management accepts no responsibility for use of the script. Rock and stone.
# Source available at https://github.com/rlowellfl/funstuff/blob/main/deeprockcopy.ps1

########
# Inputs
########

# Input the path to your Steam save FILE, the path to your DRG Xbox save DIRECTORY, and the location to back up saves to prior to making changes:
# More info on finding your save locations can be found here: https://www.reddit.com/r/DeepRockGalactic/comments/e7hptr/how_to_transfer_your_steam_save_to_windows_10_and/

$steamsavefile = "<your path to the Steam DRG install location>\Deep Rock Galactic\FSD\Saved\SaveGames\<your file ending in>_Player.sav"

$xboxsavepath = "C:\Users\<your user folder>\AppData\Local\Packages\CoffeeStainStudios.DeepRockGalactic_<some random string>\SystemAppData\wgs\<some random folder name, copy yours>\<some other random folder name, copy yours. Don't include the save file name, just end the path with a slash>\"

$backuplocation = "<your preferred backup location, such as C:\temp\drg>"

########
# Script
########

# Get the name of the Xbox save file name, because the damn thing changes every time

$xboxsavefile = $xboxsavepath + (Get-ChildItem -Name -Path $xboxsavepath -File -Exclude container.*)

# Retrieve the last modified date and time for each save file

$xboxtime = [datetime](Get-Item $xboxsavefile).LastWriteTime
$steamtime = [datetime](Get-Item $steamsavefile).LastWriteTime

# Create a backup copy of both files before making changes

$xboxbackupdest = $backuplocation,"xboxbackup",(Get-Item $xboxsavefile).LastWriteTime.Year,(Get-Item $xboxsavefile).LastWriteTime.Month,(Get-Item $xboxsavefile).LastWriteTime.Day,(Get-Item $xboxsavefile).LastWriteTime.Hour,(Get-Item $xboxsavefile).LastWriteTime.Minute -join ""
$steambackupdest = $backuplocation,"steambackup",(Get-Item $steamsavefile).LastWriteTime.Year,(Get-Item $steamsavefile).LastWriteTime.Month,(Get-Item $steamsavefile).LastWriteTime.Day,(Get-Item $steamsavefile).LastWriteTime.Hour,(Get-Item $steamsavefile).LastWriteTime.Minute -join ""

Write-Host "Creating a backup copy of both save files to $savecopylocation..."
Copy-Item $xboxsavefile -Destination $xboxbackupdest
Copy-Item $steamsavefile -Destination $steambackupdest

# Compare versions to find the newest save game and overwrite the older version

Write-Host "Comparing DRG save game versions..."

if($xboxtime -eq $steamtime)
    {Write-Host "Both versions are the same, no action taken. Management strongly discourages wasting of company processing cycles."}
elseif ($xboxtime -gt $steamtime)
    {Write-Host "Xbox version is newer, overwriting Steam version"
    Copy-Item $xboxsavefile -Destination $steamsavefile}
elseif ($xboxtime -lt $steamtime)
    {Write-Host "Steam version is newer, overwriting Xbox version"
    Copy-Item $steamsavefile -Destination $xboxsavefile}
else
    {Write-Host "Something happened, no files copied"}

Read-Host -Prompt "Time to rock and stone, press Enter to close"

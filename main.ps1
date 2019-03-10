#Import Modules
import-module ./modules/* -force

#Import Configuration File
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json
$app_id = $config.app_id
$app_key = $config.app_key

#Main Program
Write-Host "Welcome to PS Dictionary by AndyTed"
Write-Host "Type a word to get it's definition. Press Enter to quit"
$word = ""
do {
    $word = (Read-Host -Prompt "Search Word")
    if (!$word -or ($word -match "[^a-zA-Z]")) {
        if($word) {
            write-host "Invalid input. PS Dictionary will quit now."
        }
        
        write-host "Thank you for using PS Dictionary."
        break
    }else {
        Get-Definition -word $word -app_id $app_id -app_key $app_key
    }
}while ($true)
Remove-module -name psdictionary
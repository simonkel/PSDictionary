import-module ./modules/* -force

Write-Host "Welcome to PS Dictionary by AndyTed"
Write-Host "Type a word to get it's definition. Press Enter to quit"
$word = ""
do {
    $word = (Read-Host -Prompt "Search Word")
    if (!$word -or ($word -match "[^a-zA-Z]")) {
        
        write-host "Invalid input. PS Dictionary will quit now."
        write-host "Thank you for using PS Dictionary."
        break
    }else {
        Get-Definition -word $word
    }
}while ($true)
Remove-module -name psdictionary
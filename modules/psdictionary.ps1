Function Get-Definition {
    [cmdletbinding()]Param(
        [string] $word,
        [string] $app_id,
        [string] $app_key
    )

    try {
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Accept", 'application/json')
        $headers.Add("app_id", $app_id)
        $headers.Add("app_key", $app_key)

        #Get Inflection
        $uri = "https://od-api.oxforddictionaries.com:443/api/v1/inflections/en/" + $word
        $response = Invoke-RestMethod -uri $uri -Headers $headers -Method Get
        [array]$inflections = $response.results.lexicalEntries.inflectionOf.text
        $inflections = [array]$inflections | Select-Object -unique
        
        if (($inflections.length -eq 1)){
            $word = $inflections[0].toString()
        } else {
            $others = [array]$inflections | Where-Object {$_ -ne $word} 
        }
        
        #Get Definition
        Write-Host "[ DEFINITION: $word ]" -ForegroundColor "red"
        if($others) { Write-Host "[ SEE ALSO  : $others ]" -ForegroundColor "green" }
        $jsonpath = "./words/" + $word + ".json"
        if(-not(Test-Path -Path $jsonpath)){

            $uri = "https://od-api.oxforddictionaries.com:443/api/v1/entries/en/" + $word

            $response = Invoke-RestMethod -uri $uri -Headers $headers -Method Get
            
            $response | Convertto-JSON -Depth 10 | Out-File $jsonpath
        } else {
            $response = Get-Content $jsonpath | Convertfrom-JSON 
        }
        PrintDefinition($response)
    }catch {
        Write-Host "Invalid input. Try again."
    }
}

Function PrintDefinition {
    Param (
        $response
    )
    $lexicalEntries = $response.results.lexicalEntries

    Foreach ($lexicalEntry in $lexicalEntries) {
        Write-Host ("[ " + $lexicalEntry.lexicalCategory + " ]")
        Write-Host ("[ " + $lexicalEntry.pronunciations.audioFile + " ]")
        $senses = $lexicalEntry.entries.senses

        $i = 1
        Foreach ($sense in $senses) {
            Write-Host "[$i] " -ForegroundColor "white" -NoNewline
            Write-Host $sense.short_definitions -ForegroundColor "yellow"
            Foreach ($example in $sense.examples) {
                Write-Host ("eg. " + $example.text) -ForegroundColor "cyan"
            }
            $i++
        }
        write-host ""
}
}
function Replace-Link(){
    param(
        [string]$folderPath,
        [string]$url,
        [string]$fixedUrl
    )

    [RegEx]$Search = [Regex]::Escape($url)
    $Replace = $fixedUrl

    ForEach ($File in (Get-ChildItem -Path "$folderPath/*.md" -Recurse -File)) {
        Write-Host $File
        $text = [System.IO.File]::ReadAllText($File)
        $replaced = [System.Text.RegularExpressions.Regex]::Replace($text, $Search, $Replace);
        [System.IO.File]::WriteAllText($File, $replaced)
    }
}
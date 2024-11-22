#imports
. "$PSScriptRoot\ps-lib\markdown-file-operations.ps1"

# Declare the path to the file containing links

if($args.count -eq 0)
{
    throw "Please pass the name or path to the markdown file as first arg!"
}

$markdownFile = $args[0]
Write-Host "markdown file: $($markdownFile)"

$folder = "/workdir"
$file = "$folder/$markdownFile"

$v = node --version

#Replace-Link $folder "http" "https"

$linksString = node /bindir/link-extraction.js $file
$links = $linksString -split " "
$areTrailingSlashesIgnored = $true
$isWwwPrefixIgnored = $true

$links | Sort-Object {Get-Random} | ForEach-Object {
    $url = $_

    try {
        $finalUri = [System.Net.HttpWebRequest]::Create($url).GetResponse().ResponseUri.AbsoluteUri
        # making one more request to the new URI to see, if there is one more redirect
        $finalUri = [System.Net.HttpWebRequest]::Create($finalUri).GetResponse().ResponseUri.AbsoluteUri

        # any changes?
        # if ($areTrailingSlashesIgnored) {
        #     if($url.Trim("/") -ne $finalUri.Trim("/")) {
        #         Write-Host "$url => $finalUri"
        #         Replace-Link $folder $url $finalUri
        #     }
        # } else {
        #     if($url -ne $finalUri) {
        #         Write-Host "$url => $finalUri"
        #         Replace-Link $folder $url $finalUri
        #     }
        # }

        # host changed?
        $old = (New-Object -TypeName System.Uri -ArgumentList $url).Host
        $new = (New-Object -TypeName System.Uri -ArgumentList $finalUri).Host

        if ($isWwwPrefixIgnored) {
            $old = [System.Text.RegularExpressions.Regex]::Replace($old, "^www.", "");
            $new = [System.Text.RegularExpressions.Regex]::Replace($new, "^www.", "");
        }

        if ($old -ne $new) {
            Write-Host "$url => $finalUri"
            Replace-Link $folder $url $finalUri
        }

    } catch {
        # ignore, we care only about the redirects, not about the 4xx or 5xx cases
    }

    Start-Sleep -Seconds 2
}
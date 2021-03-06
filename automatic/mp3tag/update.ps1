import-module au

$releases = 'http://www.mp3tag.de/en/download.html'

function global:au_SearchReplace {
   @{
        ".\tools\ChocolateyInstall.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $result = $download_page.Content -match "<h2>Mp3tag v([\d\.]+)</h2>"

    if (!$Matches) {
      throw "mp3tag version not found on $releases"
    }

    $version = $Matches[1]
    $url32   = 'http://download.mp3tag.de/mp3tagv<version>setup.exe'
    $flatVersion = $version -replace '\.', ''
    $url32   = $url32 -replace '<version>', $flatVersion

    return @{ URL32 = $url32; Version = $version }
}

update -ChecksumFor 32

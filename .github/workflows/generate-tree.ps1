$BasePath = "data/global/tiles"
$AllowedExtensions = @(".ini", ".pcx", ".png")
$OutputFile = "tree.json"

$tree = @{}

function Scan-Folder {
    param (
        [string]$Path
    )

    $items = @()

    Get-ChildItem -Path $Path | ForEach-Object {
        if ($_.PSIsContainer) {
            $items += @{
                type = "dir"
                name = $_.Name
            }
            Scan-Folder $_.FullName
        }
        else {
            if ($AllowedExtensions -contains $_.Extension.ToLower()) {
                $items += @{
                    type = "file"
                    name = $_.Name
                }
            }
        }
    }

    # Normalize path to forward slashes
    $relative = $Path.Replace("\", "/")
    $tree[$relative] = $items
}

Scan-Folder $BasePath

$tree | ConvertTo-Json -Depth 10 | Set-Content $OutputFile -Encoding UTF8

Write-Host "tree.json generated successfully."

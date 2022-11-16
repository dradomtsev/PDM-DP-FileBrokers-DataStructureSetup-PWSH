function ValidateNTFSItemV00 {
    param(
        [string] $path
    )
    $status = $null
    if (Test-Path -Path $path) {
        $status = "Item exists"
    } else {
        $status = "Item doesn't exist"
    }
    return $status
}

function GetAppConfigV00 {
    param(
        [string] $path
    )
    $status = $null
    $pathStatus = ValidateNTFSItemV00 -path $path
    $configObject = $null
    if ($pathStatus -eq  "Item exists")
    {
        $configObject = Get-Content -Raw $path | ConvertFrom-Json -AsHashtable
        $status = "App configured"
    } else {
        $status = "Can't configure app"
    }
    return $status, $configObject
}

function CreateFolderV00 {
    param(
        [string] $path,
        [string] $item
    )
    $status = $null
    $path = $path.Trim()
    $item = $item.Trim()
    $itemResult = New-Item -Path $path -Name $item -ItemType Directory
    if($itemResult -eq $null) {
        $status = "New-Item cancelled: item already exist"
        return $status
    } else {
        $status = ValidateNTFSItemV00 -path $itemResult
    }
    
    return $status
}
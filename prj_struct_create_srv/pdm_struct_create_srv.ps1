Import-Module -Name "C:\Users\drado\source\repos\pdm\pdm_lib\pdm_lib.psd1" -Verbose -RequiredVersion 0.0.0.1
function main{
    param(

    )
    $status, $configObject = GetAppConfigV00 -path 'C:\Users\drado\source\repos\pdm\prj_struct_create_srv\appsettings.json'
    if ($status -ne "App configured") {
        return "Can't configure app"
    }

    $scriptType = $configObject.configset.ScriptType
    #$job = 
    $configObject.configset.DataStructure
    $itemLevel = $null
    $itemLevel = $configObject.configset.DataStructure.Level

    $configObject.configset.DataStructure.Value | ForEach-Object {# Parallel {
        $pathStatus = ValidateNTFSItemV00 -path $_
        if ($pathStatus -ne "Item exists") {
            return "$itemLevel folder $_ doesn't exist"
        }

        $path = $_
        $itemLevel = $null
        $itemLevel = $configObject.configset.DataStructure.Items.Level

        $configObject.configset.DataStructure.Items.Value | ForEach-Object {
            $pathFull= -join($path, "\", $_)
            $pathStatus = ValidateNTFSItemV00 -path $pathFull
            if ($pathStatus -ne "Item exists") {
                Write-Host "$itemLevel folder $_ doesn't exist"
                $status = CreateFolderV00 -path $path -item $_
                # if (($scriptType -eq "all") -or ($scriptType -eq "project")) {}
            }
            $itemLevel = $null
            $itemLevel = $configObject.configset.DataStructure.Items.Items.Level
            $path = $pathFull

            $configObject.configset.DataStructure.Items.Items.Value | ForEach-Object {
                $pathFull = -join($path, "\", $_)
                $pathStatus = ValidateNTFSItemV00 -path $pathFull
                if ($pathStatus -ne "Item exists") {
                    Write-Host "$itemLevel folder $_ doesn't exist"
                    $status = CreateFolderV00 -path $path -item $_
                    $itemLevel = $null
                    $itemLevel = $configObject.configset.DataStructure.Items.Items.Items.Level

                    $itemLevel
                }
            }
        }
    } #-AsJob
    #$job | Receive-Job -Wait

}
main
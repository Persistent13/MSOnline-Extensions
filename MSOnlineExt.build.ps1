task Deploy UpdateManifest, UnloadModule, Test, UnloadModule, LoadModule {
    $deploy_root = Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'Deploy'
    Invoke-PSDeploy -DeploymentRoot $deploy_root
}
task Test {
    $test_path = Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'Test'
    Invoke-Pester $test_path
}
task LoadModule {
    if(-not (Get-Module -Name 'MSOnlineExt')){ Import-Module $manifest_path }
}
task UnloadModule {
    if(Get-Module -Name 'MSOnlineExt'){ Remove-Module -Name 'MSOnlineExt' }
}
task UpdateManifest {
    $functions_path = Join-Path -Path ( Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt' ) -ChildPath 'Public'
    $manifest_path = Join-Path -Path ( Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt' ) -ChildPath 'MSOnlineExt.psd1'
    $files_path = Join-Path -Path ( Join-Path -Path $PSScriptRoot -ChildPath 'src' ) -ChildPath 'MSOnlineExt'

    $functions = Get-ChildItem -Path $functions_path -Filter '*.ps1'
    $files = Get-ChildItem -Path $files_path -File -Recurse
    $manifest_params = @{
        Path = $manifest_path
        Copyright = '(c) {0} Dakota Clark. All rights reserved.' -f (Get-Date).Year
        FileList = $files.Name
        FunctionsToExport = $functions.BaseName
    }
    Update-ModuleManifest @manifest_params
}
task . UnloadModule, Test
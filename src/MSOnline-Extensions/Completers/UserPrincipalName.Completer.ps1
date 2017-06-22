$param_name = 'UserPrincipalName'
$cmdlets = Get-Command -Module 'MSOnline' -ParameterName $param_name

$argument_completer = @{
    CommandName = $cmdlets.Name
    ParameterName = $param_name
    ScriptBlock = {
        param($command_name, $parameter_name, $word_to_complete, $command_ast, $fake_bound_parameter)

        $item_list = Get-MsolUser | Where-Object { $PSItem.DisplayName -match $word_to_complete } | ForEach-Object {
            $completion_text = $PSItem.UserPrincipalName
            $tool_tip = 'The Tenant ID for Office 365 partners.'
            $list_item_text = $PSItem.DisplayName
            $completion_result_type = [System.Management.Automation.CompletionResultType]::ParameterValue

            New-Object [System.Management.Automation.CompletionResult]($completion_text,$list_item_text,$completion_result_type,$tool_tip)
        }

        return $item_list
    }
}

Register-ArgumentCompleter @argument_completer
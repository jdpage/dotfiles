function prompt {
	if (Test-Path variable:/PSDebugContext) {
		Write-Host '[DBG]: ' -NoNewLine -Foreground Yellow
	}
	Write-Host "PS/$($env:COMPUTERNAME.ToLower()) " -NoNewLine
	Write-Host (Get-Location).Path.Replace($Home, '~') -Foreground Green -NoNewLine
	return $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
}

function dotfiles { & git --git-dir="${HOME}/.dotfiles/" --work-tree="${HOME}" @Args }
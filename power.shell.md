#### PowerShell 

##### setup

PowerShell should be available by default on Win10. For all other and for latest version can be installed from [github](https://github.com/PowerShell/PowerShell/releases)

For linux just unzip tgz file
For windows run msi installer

Remember to run powershell as adminstrator from menu for windows or use powershell command from cmd.
For linux use ./pwsh command from your installation folder or set paths/links to use it in a common way.

##### basics 

first commands

    $PSversionTable
    update-help
    get-help
    get-command
    get-process
    get-process -listavailable

terminal colors - check current colors

    Get-PSReadlineOption | Select *color

terminal colors - set your scheme : `vi/notepad $PROFILE`

    ############################### CUT HERE ###############################
    # colors : Black, Red, DarkRed, Magneta, DarkMagenta, Yellow, DarkYellow, Gray, DarkGray,
    #          Blue, DarkBlue, Green, DarkGreen, Cyan, DarkCyan, White

    #$host.ui.rawui.backgroundcolor = "Black"
    #$host.ui.rawui.foregroundcolor = "White"
    $host.PrivateData.ErrorForegroundColor = "Red"
    $host.PrivateData.ErrorBackgroundColor = "White"
    $host.PrivateData.WarningForegroundColor = "Yellow"
    $host.PrivateData.WarningBackgroundColor = "White"
    $host.PrivateData.DebugForegroundColor = "Yellow"
    $host.PrivateData.DebugBackgroundColor = "White"
    $host.PrivateData.VerboseForegroundColor = "Green"
    $host.PrivateData.VerboseBackgroundColor = "Magenta"
    $host.PrivateData.ProgressForegroundColor = "Yellow"
    $host.PrivateData.ProgressBackgroundColor = "DarkCyan"
    Set-PSReadlineOption -Colors @{
     "Command" = 'Yellow'
     "Comment" = 'Blue'
     "ContinuationPrompt" = 'Yellow'
     "DefaultToken" = 'Magneta'
     "Emphasis" = 'Yellow'
     "Error" = 'Red'
     "Keyword" = 'DarkYellow'
     "Member" = 'Yellow'
     "Number" = 'Gray'
     "Operator" = 'DarkYellow'
     "Parameter" = 'DarkYellow'
     "Selection" = 'DarkYellow'
     "String" = 'Gray'
     "Type" = 'Yellow'
     "Variable" = 'Blue'
    }
    ############################### CUT HERE ###############################

add proxy for windows configuration to access repos in config : `notepad $PROFILE`

    [system.net.webrequest]::defaultwebproxy = new-object system.net.webproxy('http://ProxyHost:ProxyPort')
    [system.net.webrequest]::defaultwebproxy.credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
    [system.net.webrequest]::defaultwebproxy.BypassProxyOnLocal = $true

add proxy for linux configuration to access repos in config : `vi $PROFILE`

    [system.net.webrequest]::defaultwebproxy = new-object system.net.webproxy('http://ProxyHost:ProxyPort')
    [system.net.webrequest]::defaultwebproxy.credentials = New-Object System.Net.NetworkCredential('user', 'password')
    [system.net.webrequest]::defaultwebproxy.BypassProxyOnLocal = $true

verify network access

    Invoke-WebRequest http://www.google.com

register default repo

    Register-PSRepository -Default

##### working with modules

basic help

    Get-Module -?

list modules & commnads

    Get-Module -listavailable
    Get-Command -Module ActiveDirectory
    Get-Module ActiveDirectory | Get-Member -MemberType Property | Format-Table Name
    Get-Module ActiveDirectory | % { $_.ExportedCommands.Values }

##### working with variables

get information about variables

    Get-Variable PROFILE | Format-List *
    Get-Variable PROFILE
    Get-Variable PROFILE | Select Value,Visibility

##### working with objects

basic debug

    Get-WmiObject -Class "Win32_computersystem" | Select *
    Get-WmiObject -Class "Win32_computersystem" | Get-Member
    Get-WmiObject -Class "Win32_computersystem" | Format-List *

    Get-ItemProperty C:\Windows
    Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion
    Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion -Name "ProgramFilesDir"

##### working with scripts

allow scripts execution (check and set policy)

    Get-ExecutionPolicy
    > Restricted
    Set-ExecutionPolicy RemoteSigned

run script

    mkdir ps
    .\ps\Install-ADModule.ps1


##### working with AD

get info about domains and users

    Get-ADDomain
    Get-ADUser userX


##### links

 * [install AD module](https://blogs.technet.microsoft.com/ashleymcglone/2016/02/26/install-the-active-directory-powershell-module-on-windows-10/)

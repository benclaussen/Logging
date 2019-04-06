function Set-LoggingVariables{
    param()

    #Already setup
    if($Logging -and $LogTargets -and $LevelNames){
        return
    }

    Write-Verbose -Message ("{0} :: Initial variable setup.")
    
    $Script:NOTSET     = 0
    $Script:DEBUG      = 10
    $Script:INFO       = 20
    $Script:WARNING    = 30
    $Script:ERROR_     = 40

    $initialLevels = [hashtable]::Synchronized(@{
        $NOTSET = 'NOTSET'
        $ERROR_ = 'ERROR'
        $WARNING = 'WARNING'
        $INFO = 'INFO'
        $DEBUG = 'DEBUG'
        'NOTSET' = $NOTSET
        'ERROR' = $ERROR_
        'WARNING' = $WARNING
        'INFO' = $INFO
        'DEBUG' = $DEBUG
    })

    New-Variable -Name LevelNames   -Scope Script -Value $initialLevels -Option Constant
    New-Variable -Name Logging      -Scope Script -Value ([hashtable]::Synchronized(@{})) -Option Constant
    New-Variable -Name LogTargets   -Scope Script -Value ([hashtable]::Synchronized(@{})) -Option Constant
    New-Variable -Name ScriptRoot   -Scope Script -Value ([System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Module.Path)) -Option Constant
    New-Variable -Name Defaults -Scope Script -Option Constant -Value @{
        Level       = $Script:NOTSET
        Format      = '[%{timestamp:+%Y-%m-%d %T%Z}] [%{level:-7}] %{message}'
        Timestamp   = '%Y-%m-%dT%T%Z'
        CallerScope = 1
    }
    
    $Script:Logging.Level      = $Defaults.Level
    $Script:Logging.Format     = $Defaults.Format
    $Script:Logging.CallerScope = $Defaults.CallerScope
    $Script:Logging.Targets    = [hashtable]::Synchronized(@{})
    $Script:Logging.CustomTargets = [String]::Empty
}
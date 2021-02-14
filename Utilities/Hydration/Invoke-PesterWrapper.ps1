<#
.SYNOPSIS
Test a specific test file

.DESCRIPTION
Test a specific test file

.PARAMETER TestFile
The test file to test

.PARAMETER TestDir
The location of the test file

.PARAMETER OutputFile
Path to the output file with the test results

.PARAMETER excludeTags
Tags to exclude during testing

.PARAMETER includeTags
Tags to include during testing

.EXAMPLE
 $result = Test-TestFile @TestFileInputObject

 Test the file with the given parameters
#>
function Test-TestFile {

    param(
        [Parameter(Mandatory = $true)]
        [string] $TestFile,
        [Parameter(Mandatory = $true)]
        [string] $TestDir,
        [Parameter(Mandatory = $true)]
        [string] $OutputFile,
        [Parameter(Mandatory = $false)]
        [string[]] $excludeTags = $(),
        [Parameter(Mandatory = $false)]
        [string[]] $includeTags = $(),
        $TestResultsPath = $PSScriptRoot # or choose $ENV:System_DefaultWorkingDirectory
    )

    if (-not $TestFile.EndsWith(".ps1")) {
        $TestFile = "$TestFile.ps1"
    }
    Write-Verbose "Search file '$TestFile' in dir '$TestDir'"
    $testFileObject = Get-ChildItem -Path $TestDir -Recurse -File -Filter $TestFile
    if ($testFile) {
        $testFilePath = Join-Path $testFileObject.DirectoryName $testFileObject.Name
        Write-Verbose ("Invoke test script '$TestFile' in Path '{0}'" -f $testFilePath)
        $pesterInput = @{
            Script       = $testFilePath 
            OutputFile   = $OutputFile 
            ExcludeTag   = $excludeTags 
            Tag          = $includeTags 
            OutputFormat = 'NUnitXml' 
            PassThru     = $true
        }
        $result = Invoke-Pester @pesterInput
        return $result;
    }
    else {
        throw "File by name $TestFile not found."
    }
}

<#
.SYNOPSIS
Invoke all module pester tests

.DESCRIPTION
Invoke all module pester tests under consideration of any set tags or test case

.PARAMETER ModuleRoot
Root path to the module

.PARAMETER ExcludeTags
Pester tests to exclude

.PARAMETER IncludeTags
Pester tests to include

.PARAMETER TestCase
Specfic test case to run. Excludes all other tests.

.EXAMPLE
$(Build.SourcesDirectory)/$(module.name)/Pipeline/Invoke-PesterWrapper.ps1 -IncludeTags 'Build,Unit' -ModuleRoot $(ModuleRoot)
#>
function Invoke-PesterWrapper {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String] $ModuleRoot,
        [Parameter(Mandatory = $false)]
        [String] $ExcludeTags,
        [Parameter(Mandatory = $false)]
        [String] $IncludeTags = '*',
        [Parameter(Mandatory = $false)]
        [String] $TestCase,
        [Parameter(Mandatory = $false)]
        [String] $TestFile,
        [Parameter(Mandatory = $true)]
        [String] $OutputFileName,
        [Parameter(Mandatory = $false)]
        [String] $CodeCoverageOutputFileName
    )

    if (((Get-Module 'Pester' -ListAvailable).Version | Measure-Object -Maximum).Maximum.ToString() -lt '5.1.1') {
        Write-Verbose "Installing latest Pester version as current install does not satisfy the requirements."
        Install-Module -Name 'Pester' -Force
    }
    if (-Not (Get-Module 'PSScriptAnalyzer' -ListAvailable)) {
        Install-Module -Name 'PSScriptAnalyzer' -Force
    }

    Write-Verbose "Setup tests"
    $TestDir = Join-Path $ModuleRoot "src/Tests"
    if (-not (Test-Path $TestDir)) {
        Write-Warning "Not Test directory existing at '$TestDir'. Skipping"
        return
    }

    $OutputFile = Join-Path $ModuleRoot $OutputFileName

    Write-Verbose "Start Testing"
    if (-Not [string]::IsNullOrEmpty($TestCase)) {
        Write-Verbose "Test TestCase '$TestCase'"
        $pesterInput += @{
            Path         = $TestDir 
            TestName     = $TestCase 
            OutputFile   = $OutputFile
            OutputFormat = 'NUnitXml' 
            PassThru     = $true
        }
        $result = Invoke-Pester @pesterInput
    }
    elseif (-Not [string]::IsNullOrEmpty($TestFile)) {
        Write-Verbose "Test TestFile '$TestFile'"
        $pesterInput = @{
            TestFile     = $TestFile
            TestDir      = $TestDir
            OutputFile   = $OutputFile
            IncludeTags  = $IncludeTags.Split(',').Trim()
            ExcludeTags  = $ExcludeTags.Split(',').Trim()
        }
        $result = Test-TestFile @pesterInput
    }
    else {
        Write-Verbose "Test general tests"
        $pesterInput = @{
            ExcludeTag                   = $ExcludeTags.Split(',').Trim()
            Tag                          = $IncludeTags.Split(',').Trim()
            Script                       = $TestDir
            OutputFile                   = $OutputFile
            OutputFormat                 = "NUnitXml"
            PassThru                     = $true
        }
        if($CodeCoverageOutputFileName) {
            $pesterInput += @{
                CodeCoverage                 = "$TestDir\*"
                CodeCoverageOutputFile       = Join-Path $ModuleRoot $CodeCoverageOutputFileName
                CodeCoverageOutputFileFormat = 'JaCoCo'
            }
        }
        
        $result = Invoke-Pester @pesterInput
    }
    Write-Verbose "Exported test results to $OutputFile"
    $result
}

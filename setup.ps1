
param(
    $global:GitUser = "grin-malkin",
    [Parameter(Mandatory=$true)]
    [string]$Name,
    [string]$CustomName = "Project",
    [switch]$UnitTest,
    [Parameter(Mandatory=$true)]
    [string]$Language
)

switch ($Language.ToLower()) {
    "dotnet" { 
        dotnet new sln -o "$Name"

        Set-Location -Path ".\$Name"

        dotnet new classlib -o "$CustomName"

        dotnet sln add .\$CustomName\$CustomName.csproj

        if ($UnitTest -eq $true) {
            dotnet new xunit -o "$CustomName.Tests"
            dotnet sln add .\$CustomName.Tests\$CustomName.Tests.csproj
            dotnet add .\$CustomName.Tests\$CustomName.Tests.csproj reference .\$CustomName\$CustomName.csproj
        }

        Rename-Item -Path ".\$CustomName/Class1.cs" -NewName "$CustomName.cs"
        Rename-Item -Path ".\$CustomName.Tests/UnitTest1.cs" -NewName "$($CustomName)Test.cs"     
     }
     "rust" {
        if ($UnitTest -eq $true) {
            cargo new --lib $Name
        } else {
            cargo new --bin $Name
        }
     }
    "go" {
        New-Item -ItemType Directory -Path ".\$Name"
        Set-Location -Path ".\$Name"

        go mod init "github.com/$GitUser/$Name"
    }
    Default {
        Write-Output "Could not resolve that language. Maybe soon we add this to our script! :)"
    }
}
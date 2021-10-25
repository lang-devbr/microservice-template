cls
@echo off
@color F
@ECHO --------------------------------------------------------------
@ECHO TEMPLATE MICROSERVICE
@ECHO --------------------------------------------------------------
@ECHO .NET Core (latest)  - C#
@ECHO --------------------------------------------------------------    
@ECHO CLEAN ARCHITECTURE
@ECHO --------------------------------------------------------------
@color
REM @echo off
set /p solutionName="Enter the name of the solution without spaces: " 

dotnet new sln -o %solutionName%
cd %solutionName%

dotnet new webapi -o %solutionName%.Api
dotnet new classlib -o %solutionName%.Application
dotnet new classlib -o %solutionName%.Domain
dotnet new classlib -o %solutionName%.Infra
dotnet new xunit -o %solutionName%.Tests
@ECHO ............................................
dotnet sln add ./%solutionName%.Api/%solutionName%.Api.csproj
dotnet sln add ./%solutionName%.Application/%solutionName%.Application.csproj
dotnet sln add ./%solutionName%.Domain/%solutionName%.Domain.csproj
dotnet sln add ./%solutionName%.Infra/%solutionName%.Infra.csproj
dotnet sln add ./%solutionName%.Tests/%solutionName%.Tests.csproj
@ECHO ............................................
@ECHO Deleting default class
@ECHO deleting "%CD%\%solutionName%.Application\Class1.cs"
del "%CD%\%solutionName%.Application\Class1.cs"
@ECHO deleting "%CD%\%solutionName%.Domain\Class1.cs"
del "%CD%\%solutionName%.Domain\Class1.cs"
@ECHO deleting "%CD%\%solutionName%.Infra\Class1.cs"
del "%CD%\%solutionName%.Infra\Class1.cs"
@ECHO ............................................
@ECHO Creating folder structure
md "%CD%\%solutionName%.Api\Configurations"
md "%CD%\%solutionName%.Api\Options"
md "%CD%\%solutionName%.Application\Base"
md "%CD%\%solutionName%.Application\Commands"
md "%CD%\%solutionName%.Application\Queries"
md "%CD%\%solutionName%.Application\Contracts"
md "%CD%\%solutionName%.Domain\AggregateModels"

md "%CD%\%solutionName%.Infra\Data"
md "%CD%\%solutionName%.Infra\Data\Contexts"
md "%CD%\%solutionName%.Infra\Data\Mappings"
md "%CD%\%solutionName%.Infra\Data\Repositories"
md "%CD%\%solutionName%.Infra\Integrations"
md "%CD%\%solutionName%.Infra\Integrations\HttpServices"
md "%CD%\%solutionName%.Infra\Integrations\QueueServices"

powershell -Command "(gc "%CD%\%solutionName%.Api\%solutionName%.Api.csproj") -replace '</Project>', '<ItemGroup><Folder Include=\"Configurations\" /><Folder Include=\"Options\" /></ItemGroup></Project>' | Out-File -encoding ascii "%CD%\%solutionName%.Api\%solutionName%.Api.csproj"
powershell -Command "(gc "%CD%\%solutionName%.Application\%solutionName%.Application.csproj") -replace '</Project>', '<ItemGroup><Folder Include=\"Base\" /><Folder Include=\"Commands\" /><Folder Include=\"Queries\" /><Folder Include=\"Contracts\" /></ItemGroup></Project>' | Out-File -encoding ascii "%CD%\%solutionName%.Application\%solutionName%.Application.csproj"
powershell -Command "(gc "%CD%\%solutionName%.Domain\%solutionName%.Domain.csproj") -replace '</Project>', '<ItemGroup><Folder Include=\"AggregateModels\" /></ItemGroup></Project>' | Out-File -encoding ascii "%CD%\%solutionName%.Domain\%solutionName%.Domain.csproj"
powershell -Command "(gc "%CD%\%solutionName%.Infra\%solutionName%.Infra.csproj") -replace '</Project>', '<ItemGroup><Folder Include=\"Data\Contexts\" /><Folder Include=\"Data\Mappings\" /><Folder Include=\"Data\Repositories\" /><Folder Include=\"Integrations\HttpServices\" /><Folder Include=\"Integrations\QueueServices\" /></ItemGroup></Project>' | Out-File -encoding ascii "%CD%\%solutionName%.Infra\%solutionName%.Infra.csproj"

@ECHO ............................................
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj reference ./%solutionName%.Application/%solutionName%.Application.csproj
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj reference ./%solutionName%.Domain/%solutionName%.Domain.csproj
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj reference ./%solutionName%.Infra/%solutionName%.Infra.csproj
dotnet add ./%solutionName%.Application/%solutionName%.Application.csproj reference ./%solutionName%.Infra/%solutionName%.Infra.csproj
dotnet add ./%solutionName%.Infra/%solutionName%.Infra.csproj reference ./%solutionName%.Domain/%solutionName%.Domain.csproj
dotnet add ./%solutionName%.Tests/%solutionName%.Tests.csproj reference ./%solutionName%.Domain/%solutionName%.Domain.csproj
@ECHO ............................................
dotnet new nugetconfig -o Nuget.config

set /p fwsDefault="Enter 'yes' if you want to install the default frameworks (EF Core, MediatR, Swagger and serilog): " 

IF %fwsDefault%==yes goto addDefaultPackages
IF %fwsDefault%==YES goto addDefaultPackages
IF %fwsDefault%==Yes goto addDefaultPackages
IF %fwsDefault%==y goto addDefaultPackages
IF %fwsDefault%==Y goto addDefaultPackages

ECHO Do not add packages
goto end

:addDefaultPackages
@ECHO ............................................
@echo Adding default frameworks packages
@ECHO ............................................
rem Adding api packages
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj package MediatR
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj package Microsoft.Extensions.Options
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj package Microsoft.EntityFrameworkCore.Tools
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj package Serilog
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj package Serilog.Sinks.Console
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj package Serilog.Sinks.Http
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj package Serilog.Settings.Configuration
dotnet add ./%solutionName%.Api/%solutionName%.Api.csproj package Swashbuckle.AspNetCore
rem Adding application packages
dotnet add ./%solutionName%.Application/%solutionName%.Application.csproj package MediatR
rem Adding infra packages
dotnet add ./%solutionName%.Infra/%solutionName%.Infra.csproj package Microsoft.EntityFrameworkCore
dotnet add ./%solutionName%.Infra/%solutionName%.Infra.csproj package Microsoft.EntityFrameworkCore.Design
dotnet add ./%solutionName%.Infra/%solutionName%.Infra.csproj package Microsoft.EntityFrameworkCore.Tools
dotnet add ./%solutionName%.Infra/%solutionName%.Infra.csproj package Pomelo.EntityFrameworkCore.MySql

:end

@ECHO Building solution structure
dotnet build %solutionName%.sln

color A
@ECHO ------------------------------------------------------------------    
@ECHO ------------------------------------------------------------------
@ECHO .
@ECHO TEMPLATE SUCCESSFULLY COMPLETED!
@ECHO .
@ECHO ------------------------------------------------------------------
@ECHO ------------------------------------------------------------------
@pause
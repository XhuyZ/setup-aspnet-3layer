#!/bin/bash
# Set project name from user input
read -p "Go to ~/ Enter your project name: " PROJECT_NAME

# Create the main solution directory
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Initialize a new solution
dotnet new sln -n API
# Create the main Web API project and 3-layer-architechture
dotnet new webapi -n API
dotnet new classlib -n BLL
dotnet new classlib -n DAL
dotnet new classlib -n Common
#Add Project to Solution
dotnet sln add API/API.csproj
dotnet sln add BLL/BLL.csproj
dotnet sln add Common/Common.csproj
dotnet sln add DAL/DAL.csproj
# Add References
dotnet add API/API.csproj reference BLL/BLL.csproj
dotnet add API/API.csproj reference DAL/DAL.csproj
dotnet add API/API.csproj reference Common/Common.csproj
dotnet add DAL/DAL.csproj reference Common/Common.csproj
dotnet add BLL/BLL.csproj reference Common/Common.csproj
dotnet add BLL/BLL.csproj reference DAL/DAL.csproj
# DAL (Data Access Layer)
cd DAL
mkdir -p Configuration
mkdir -p Context
mkdir -p Entities
mkdir -p Entities
mkdir -p Migrations
mkdir -p Repositories/{Interfaces,Implementation}
rm -rf Class1.cs
# Go to root solution
cd ..
# BLL (Business Logic Layer)
mkdir -p DTOs
mkdir -p Exceptions
mkdir -p Interfaces
mkdir -p Mappers
mkdir -p Services
rm -rf Class1.cs

# # Create example files
# echo "namespace $PROJECT_NAME.Common.Models { public class SampleModel { public int Id { get; set; } public string Name { get; set; } } }" > $PROJECT_NAME.Common/Models/SampleModel.cs
#
# echo "namespace $PROJECT_NAME.BLL.Services { public class SampleService { } }" > $PROJECT_NAME.BLL/Services/SampleService.cs
#
# echo "namespace $PROJECT_NAME.DAL.Repositories { public class SampleRepository { } }" > $PROJECT_NAME.DAL/Repositories/SampleRepository.cs
#
# echo "using Microsoft.AspNetCore.Mvc; namespace $PROJECT_NAME.API.Controllers { [Route(\"api/[controller]\")] [ApiController] public class SampleController : ControllerBase { [HttpGet] public string Get() { return \"Hello World!\"; } } }" > $PROJECT_NAME.API/Controllers/SampleController.cs
#
# # Restore dependencies
# dotnet restore
#
# echo "Setup complete! Navigate to $PROJECT_NAME and start coding."

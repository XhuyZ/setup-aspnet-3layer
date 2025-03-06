#!/bin/bash
# Set project name from user input
read -p "Go to ~/ Enter your project name: " PROJECT_NAME

# Create the main solution directory
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Initialize a new solution
dotnet new sln -n API
# Create the main Web API project
dotnet new webapi -n API
dotnet new classlib -n BLL
dotnet new classlib -n DAL
dotnet new classlib -n Common
dotnet sln add API/API.csproj
dotnet sln add BLL/BLL.csproj
dotnet sln add Common/Common.csproj
dotnet sln add DAL/DAL.csproj
# # Create the 3-layer architecture
# mkdir -p $PROJECT_NAME.BLL
# mkdir -p $PROJECT_NAME.DAL
# mkdir -p $PROJECT_NAME.Common
#
# # Create Class Library projects
#
# # Add them to the solution
# dotnet sln add $PROJECT_NAME.BLL
# dotnet sln add $PROJECT_NAME.DAL
# dotnet sln add $PROJECT_NAME.Common
#
# # Add References
# dotnet add $PROJECT_NAME.BLL reference $PROJECT_NAME.Common
# dotnet add $PROJECT_NAME.DAL reference $PROJECT_NAME.Common
# dotnet add $PROJECT_NAME.API reference $PROJECT_NAME.BLL
# dotnet add $PROJECT_NAME.API reference $PROJECT_NAME.DAL
#
# # Create necessary folders
# mkdir -p $PROJECT_NAME.API/Controllers
# mkdir -p $PROJECT_NAME.BLL/Services
# mkdir -p $PROJECT_NAME.DAL/Repositories
# mkdir -p $PROJECT_NAME.Common/Models
#
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

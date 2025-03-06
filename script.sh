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
cd BLL
mkdir -p DTOs
mkdir -p Exceptions
mkdir -p Interfaces
mkdir -p Mappers
mkdir -p Services
rm -rf Class1.cs
# Go to root solution
cd ..
# Common file structure
cd Common
mkdir -p Constants
mkdir -p Enums
mkdir -p Extensions
mkdir -p Helpers
rm -rf Class1.cs
# Go to root solution
cd ..
# Adding Sample Library
cd DAL
dotnet add package AutoMapper
dotnet add package Microsoft.EntityFrameWork -v8.0.11
dotnet add package Microsoft.EntityFrameWorkCore.Design -v8.0.11
dotnet add package Microsoft.EntityFrameWorkCore.Tools -v8.0.11
dotnet add NewtonSoft.Json
dotnet add Pomelo.EntityFrameWorkCore.MySql -v8.0.2
dotnet add System.Configuration.ConfigurationManager
dotnet add System.Linq
dotnet add System.Linq.Queryable
dotnet add System.Text.Json

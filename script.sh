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
# Navigate to the DAL directory
cd DAL || {
  echo "DAL directory not found! Exiting..."
  exit 1
}
dotnet add package AutoMapper -v 14.0.0
dotnet add package Microsoft.EntityFrameWorkCore -v 8.0.11
dotnet add package Microsoft.EntityFrameWorkCore.Design -v 8.0.11
dotnet add package Microsoft.EntityFrameWorkCore.Tools -v 8.0.11
dotnet add package NewtonSoft.Json
dotnet add package Pomelo.EntityFrameWorkCore.MySql -v 8.0.2
dotnet add package System.Configuration.ConfigurationManager
dotnet add package System.Linq
dotnet add package System.Linq.Queryable
dotnet add package System.Text.Json
echo "All packages installed successfully in the DAL project."
# Go to root solution
cd ..
# Navigate to the BLL directory
cd BLL || {
  echo "BLL directory not found! Exiting..."
  exit 1
}
# Add required NuGet packages
dotnet add package AutoMapper -v 14.0.0
dotnet add package MailKit -v 4.10.0
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer -v 8.0.11
dotnet add package Microsoft.IdentityModel.Tokens -v 8.5.0
dotnet add package MimeKit -v 4.10.0
dotnet add package System.IdentityModel.Tokens.Jwt -v 8.5.0
echo "All packages installed successfully in the BLL project."
# Go to root solution
cd ..
# Navigate to the API directory
cd API || {
  echo "API directory not found! Exiting..."
  exit 1
}
# Add required NuGet packages
dotnet add package AutoMapper -v 14.0.0
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer -v 8.0.11
dotnet add package Microsoft.AspNetCore.OpenApi -v 8.0.12
dotnet add package Microsoft.EntityFrameworkCore -v 8.0.11
dotnet add package Microsoft.EntityFrameworkCore.Design -v 8.0.11
dotnet add package Microsoft.EntityFrameworkCore.Tools -v 8.0.11
dotnet add package Microsoft.IdentityModel.Tokens -v 8.5.0
dotnet add package Pomelo.EntityFrameworkCore.MySql -v 8.0.2
dotnet add package Swashbuckle.AspNetCore -v 7.2.0
dotnet add package Swashbuckle.AspNetCore.Annotations -v 7.2.0
dotnet add package Swashbuckle.AspNetCore.Swagger -v 7.2.0
dotnet add package Swashbuckle.AspNetCore.SwaggerGen -v 7.2.0
dotnet add package Swashbuckle.AspNetCore.SwaggerUI -v 7.2.0
dotnet add package System.Configuration.ConfigurationManager -v 9.0.2
dotnet add package System.IdentityModel.Tokens.Jwt -v 8.5.0
dotnet add package System.Linq -v 4.3.0
echo "All packages installed successfully in the API project."

#!/bin/bash

printf "\n"
printf "  __   ___                 ______  \n"
printf "  \\ \\ / / |               |___  /  \n"
printf "   \\ V /| |__  _   _ _   _   / /   \n"
printf "    > < | '_ \\| | | | | | | / /    \n"
printf "   / . \\| | | | |_| | |_| |/ /__   \n"
printf "  /_/ \\_\\_| |_|\\__,_|\\__, /_____|  \n"
printf "                      __/ |        \n"
printf "                     |___/         \n"
printf "\n"
printf "  Automated ASP.NET Core 3-Layer Architecture Setup\n"
printf "  GitHub: https://github.com/XhuyZ\n"
printf "  License: MIT\n"
printf "============================================================\n\n"
# Set project name from user input
read -p "Go to ~/ Enter your project name: " PROJECT_NAME

# Create the main solution directory
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Initialize a new solution
dotnet new sln -n API

# Create the main Web API project and 3-layer architecture
dotnet new webapi -n API
dotnet new classlib -n BLL
dotnet new classlib -n DAL
dotnet new classlib -n Common

# Add projects to the solution
dotnet sln add API/API.csproj
dotnet sln add BLL/BLL.csproj
dotnet sln add Common/Common.csproj
dotnet sln add DAL/DAL.csproj

# Add project references
dotnet add API/API.csproj reference BLL/BLL.csproj
dotnet add API/API.csproj reference DAL/DAL.csproj
dotnet add API/API.csproj reference Common/Common.csproj
dotnet add DAL/DAL.csproj reference Common/Common.csproj
dotnet add BLL/BLL.csproj reference Common/Common.csproj
dotnet add BLL/BLL.csproj reference DAL/DAL.csproj

# Create folder structure for DAL (Data Access Layer)
cd DAL
mkdir -p Configuration Context Entities Migrations Repositories/{Interfaces,Implementation}
rm -rf Class1.cs
cd ..

# Create folder structure for BLL (Business Logic Layer)
cd BLL
mkdir -p DTOs Exceptions Interfaces Mappers Services
rm -rf Class1.cs
cd ..

# Create folder structure for Common
cd Common
mkdir -p Constants Enums Extensions Helpers
rm -rf Class1.cs
cd ..

# Adding required NuGet packages

# DAL Packages
cd DAL || {
  echo "❌ ERROR: DAL directory not found! Exiting..."
  exit 1
}
echo "🚀 Installing DAL packages..."
dotnet add package AutoMapper -v 14.0.0
dotnet add package Microsoft.EntityFrameworkCore -v 8.0.11
dotnet add package Microsoft.EntityFrameworkCore.Design -v 8.0.11
dotnet add package Microsoft.EntityFrameworkCore.Tools -v 8.0.11
dotnet add package Newtonsoft.Json
dotnet add package Pomelo.EntityFrameworkCore.MySql -v 8.0.2
dotnet add package System.Configuration.ConfigurationManager
dotnet add package System.Linq
dotnet add package System.Linq.Queryable
dotnet add package System.Text.Json
echo "✅ DAL packages installed successfully."
cd ..

# BLL Packages
cd BLL || {
  echo "❌ ERROR: BLL directory not found! Exiting..."
  exit 1
}
echo "🚀 Installing BLL packages..."
dotnet add package AutoMapper -v 14.0.0
dotnet add package MailKit -v 4.10.0
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer -v 8.0.11
dotnet add package Microsoft.IdentityModel.Tokens -v 8.5.0
dotnet add package MimeKit -v 4.10.0
dotnet add package System.IdentityModel.Tokens.Jwt -v 8.5.0
echo "✅ BLL packages installed successfully."
cd ..

# API Packages
cd API || {
  echo "❌ ERROR: API directory not found! Exiting..."
  exit 1
}
echo "🚀 Installing API packages..."
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
echo "✅ API packages installed successfully."

echo "🎉 Setup complete! Your .NET Core Web API project is ready!"
echo "📜 License: MIT | 💻 GitHub: https://github.com/XhuyZ"

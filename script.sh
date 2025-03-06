#!/bin/bash
clear
move_cursor() {
  echo -ne "\033[${1};${2}H"
}
save_cursor_position() {
  echo -ne "\033[s"
}
restore_cursor_position() {
  echo -ne "\033[u"
}
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
PROGRESS_ROW=$((TERM_HEIGHT - 2))
STATUS_ROW=$((TERM_HEIGHT - 3))
display_progress() {
  local total=$1
  local current=$2
  local task_name=$3
  local bar_size=40
  local filled=$((current * bar_size / total))
  local empty=$((bar_size - filled))
  local progress_percent=$((current * 100 / total))
  local icon="*"
  if [[ $current -eq $total ]]; then
    icon="[DONE]"
  elif [[ $progress_percent -gt 75 ]]; then
    icon="[>>>]"
  elif [[ $progress_percent -gt 50 ]]; then
    icon="[>>-]"
  elif [[ $progress_percent -gt 25 ]]; then
    icon="[>--]"
  fi
  local bar=""
  for ((i = 0; i < filled; i++)); do
    bar="${bar}█"
  done
  for ((i = 0; i < empty; i++)); do
    bar="${bar}░"
  done
  save_cursor_position
  move_cursor $STATUS_ROW 0
  printf "\033[K"
  printf "${icon} %s" "$task_name"
  move_cursor $PROGRESS_ROW 0
  printf "\033[K"
  printf "[%s] %d%%" "$bar" "$progress_percent"
  restore_cursor_position
}
log_message() {
  save_cursor_position
  echo "$1"
  restore_cursor_position
}
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
printf "\n\n"
read -p "Go to ~/ Enter your project name: " PROJECT_NAME
mkdir $PROJECT_NAME
cd $PROJECT_NAME
save_cursor_position
move_cursor $((STATUS_ROW - 1)) 0
printf "============================================================\n"
restore_cursor_position
log_message "◆ Creating solution structure..."
total_steps=4
current_step=0
display_progress $total_steps $current_step "Creating solution"
dotnet new sln -n API &>/dev/null
current_step=$((current_step + 1))
display_progress $total_steps $current_step "Creating solution"
display_progress $total_steps $current_step "Creating projects"
dotnet new webapi -n API &>/dev/null
dotnet new classlib -n BLL &>/dev/null
dotnet new classlib -n DAL &>/dev/null
dotnet new classlib -n Common &>/dev/null
current_step=$((current_step + 1))
display_progress $total_steps $current_step "Creating projects"
display_progress $total_steps $current_step "Adding projects to solution"
dotnet sln add API/API.csproj &>/dev/null
dotnet sln add BLL/BLL.csproj &>/dev/null
dotnet sln add Common/Common.csproj &>/dev/null
dotnet sln add DAL/DAL.csproj &>/dev/null
current_step=$((current_step + 1))
display_progress $total_steps $current_step "Adding projects to solution"
display_progress $total_steps $current_step "Setting up project references"
dotnet add API/API.csproj reference BLL/BLL.csproj &>/dev/null
dotnet add API/API.csproj reference DAL/DAL.csproj &>/dev/null
dotnet add API/API.csproj reference Common/Common.csproj &>/dev/null
dotnet add DAL/DAL.csproj reference Common/Common.csproj &>/dev/null
dotnet add BLL/BLL.csproj reference Common/Common.csproj &>/dev/null
dotnet add BLL/BLL.csproj reference DAL/DAL.csproj &>/dev/null
current_step=$((current_step + 1))
display_progress $total_steps $current_step "Setting up project references"
log_message "◆  Creating folder structure..."
total_folders=3
current_folder=0
display_progress $total_folders $current_folder "Creating DAL folders"
cd DAL
mkdir -p Configuration Context Entities Migrations Repositories/{Interfaces,Implementations}
rm -rf Class1.cs
cd ..
current_folder=$((current_folder + 1))
display_progress $total_folders $current_folder "Creating DAL folders"
display_progress $total_folders $current_folder "Creating BLL folders"
cd BLL
mkdir -p DTOs Exceptions Interfaces Mappers Services
rm -rf Class1.cs
cd ..
current_folder=$((current_folder + 1))
display_progress $total_folders $current_folder "Creating BLL folders"
display_progress $total_folders $current_folder "Creating Common folders"
cd Common
mkdir -p Constants Enums Extensions Helpers
rm -rf Class1.cs
cd ..
current_folder=$((current_folder + 1))
display_progress $total_folders $current_folder "Creating Common folders"
cd DAL || {
  log_message "❌ ERROR: DAL directory not found! Exiting..."
  exit 1
}
log_message "◆ Installing DAL packages..."
dal_packages=(
  "AutoMapper -v 14.0.0"
  "Microsoft.EntityFrameworkCore -v 8.0.11"
  "Microsoft.EntityFrameworkCore.Design -v 8.0.11"
  "Microsoft.EntityFrameworkCore.Tools -v 8.0.11"
  "Newtonsoft.Json"
  "Pomelo.EntityFrameworkCore.MySql -v 8.0.2"
  "System.Configuration.ConfigurationManager"
  "System.Linq"
  "System.Linq.Queryable"
  "System.Text.Json"
)
total_dal_packages=${#dal_packages[@]}
current_package=0
for package in "${dal_packages[@]}"; do
  display_progress $total_dal_packages $current_package "Installing DAL: $package"
  dotnet add package $package &>/dev/null
  current_package=$((current_package + 1))
  display_progress $total_dal_packages $current_package "Installing DAL: $package"
done
cd ..
cd BLL || {
  log_message "❌ ERROR: BLL directory not found! Exiting..."
  exit 1
}
log_message "◆ Installing BLL packages..."
bll_packages=(
  "AutoMapper -v 14.0.0"
  "MailKit -v 4.10.0"
  "Microsoft.AspNetCore.Authentication.JwtBearer -v 8.0.11"
  "Microsoft.IdentityModel.Tokens -v 8.5.0"
  "MimeKit -v 4.10.0"
  "System.IdentityModel.Tokens.Jwt -v 8.5.0"
)
total_bll_packages=${#bll_packages[@]}
current_package=0
for package in "${bll_packages[@]}"; do
  display_progress $total_bll_packages $current_package "Installing BLL: $package"
  dotnet add package $package &>/dev/null
  current_package=$((current_package + 1))
  display_progress $total_bll_packages $current_package "Installing BLL: $package"
done
cd ..
cd API || {
  log_message "❌ ERROR: API directory not found! Exiting..."
  exit 1
}
log_message "📦 Installing API packages..."
api_packages=(
  "AutoMapper -v 14.0.0"
  "Microsoft.AspNetCore.Authentication.JwtBearer -v 8.0.11"
  "Microsoft.AspNetCore.OpenApi -v 8.0.12"
  "Microsoft.EntityFrameworkCore -v 8.0.11"
  "Microsoft.EntityFrameworkCore.Design -v 8.0.11"
  "Microsoft.EntityFrameworkCore.Tools -v 8.0.11"
  "Microsoft.IdentityModel.Tokens -v 8.5.0"
  "Pomelo.EntityFrameworkCore.MySql -v 8.0.2"
  "Swashbuckle.AspNetCore -v 7.2.0"
  "Swashbuckle.AspNetCore.Annotations -v 7.2.0"
  "Swashbuckle.AspNetCore.Swagger -v 7.2.0"
  "Swashbuckle.AspNetCore.SwaggerGen -v 7.2.0"
  "Swashbuckle.AspNetCore.SwaggerUI -v 7.2.0"
  "System.Configuration.ConfigurationManager -v 9.0.2"
  "System.IdentityModel.Tokens.Jwt -v 8.5.0"
  "System.Linq -v 4.3.0"
)
total_api_packages=${#api_packages[@]}
current_package=0
for package in "${api_packages[@]}"; do
  display_progress $total_api_packages $current_package "Installing API: $package"
  dotnet add package $package &>/dev/null
  current_package=$((current_package + 1))
  display_progress $total_api_packages $current_package "Installing API: $package"
done
move_cursor $STATUS_ROW 0
printf "\033[K"
move_cursor $PROGRESS_ROW 0
printf "\033[K"
log_message "\n"
log_message "✨ SETUP COMPLETE! ✨"
log_message "✓ Project structure created"
log_message "✓ All packages installed"
log_message "✓ References configured"
log_message "━━━━━━━━━━━━━━━━━━━━━━━━"
log_message "© MIT | GitHub: XhuyZ"
echo ""

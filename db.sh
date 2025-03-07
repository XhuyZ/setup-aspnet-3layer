#!/bin/bash

# Define Base Directory (Root Directory of the Project)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find the DAL directory
DAL_DIR=$(find "$BASE_DIR" -maxdepth 2 -type d -name "DAL" | head -n 1)

# Check if DAL directory exists
if [ -z "$DAL_DIR" ]; then
  echo "❌ Could not find the DAL/ directory. Please run script.sh first!"
  exit 1
fi

# Ensure we're running from the project root
cd "$BASE_DIR" || exit 1

# Check if dotnet-ef local tool is installed
if [ ! -f ".config/dotnet-tools.json" ] || ! dotnet tool list | grep -q "dotnet-ef"; then
  echo "🔧 Installing dotnet-ef as a local tool..."
  dotnet new tool-manifest
  dotnet tool install --local dotnet-ef
fi

# Define Migration Name
MIGRATION_NAME="Init"

echo "⏳ Adding migration: $MIGRATION_NAME"
dotnet tool run dotnet-ef migrations add "$MIGRATION_NAME" --project "$DAL_DIR/DAL.csproj" --context DAL.Context.AppDBContext

if [ $? -ne 0 ]; then
  echo "❌ Migration failed!"
  exit 1
fi

echo "✅ Migration added successfully!"

# Apply Migration
echo "⏳ Applying migration..."
dotnet tool run dotnet-ef database update --project "$DAL_DIR/DAL.csproj" --context DAL.Context.AppDBContext

if [ $? -ne 0 ]; then
  echo "❌ Database update failed!"
  exit 1
fi

echo "✅ Database migration applied successfully!"

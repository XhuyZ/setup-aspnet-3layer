#!/bin/bash
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR=$(find "$BASE_DIR" -maxdepth 2 -type d -name "Common" | head -n 1)
if [ -z "$COMMON_DIR" ]; then
  echo "❌ Could not find the Common/ directory. Please run script.sh first!"
  exit 1
fi
echo "✅ Found the Common/ directory at: $COMMON_DIR"
CONSTANTS_DIR="$COMMON_DIR/Constants"
ENUMS_DIR="$COMMON_DIR/Enums"
EXTENSION_DIR="$COMMON_DIR/Extension"
HELPERS_DIR="$COMMON_DIR/Helpers"
mkdir -p "$CONSTANTS_DIR" "$ENUMS_DIR" "$EXTENSION_DIR" "$HELPERS_DIR"
cat >"$CONSTANTS_DIR/AppConstants.cs" <<EOL
namespace Common.Constants
{
    public static class AppConstants
    {
        public const string AppName = "My Application";
        public const string DateFormat = "yyyy-MM-dd";
    }
}
EOL
cat >"$ENUMS_DIR/UserRole.cs" <<EOL
namespace Common.Enums
{
    public enum UserRole
    {
        Admin,
        Manager,
        Staff,
        Supplier,
        Customer
    }
}
EOL
cat >"$ENUMS_DIR/StorageType.cs" <<EOL
namespace Common.Enums
{
    public enum StorageType
    {
        Cold,
        Normal,
        Dry
    }
}
EOL
cat >"$EXTENSION_DIR/StringExtensions.cs" <<EOL
namespace Common.Extension
{
    public static class StringExtensions
    {
        public static bool IsNullOrEmpty(this string? value) => string.IsNullOrEmpty(value);
        
        public static bool IsNullOrWhiteSpace(this string? value) => string.IsNullOrWhiteSpace(value);
    }
}
EOL
cat >"$HELPERS_DIR/DateHelper.cs" <<EOL
using System;

namespace Common.Helpers
{
    public static class DateHelper
    {
        public static string GetCurrentDateFormatted() =>
            DateTime.UtcNow.ToString(Common.Constants.AppConstants.DateFormat);
    }
}
EOL
cat >"$HELPERS_DIR/PasswordHelper.cs" <<EOL
using System;
using System.Security.Cryptography;
using System.Text;

namespace Common.Helpers
{
    public static class PasswordHelper
    {
        public static string HashPassword(string password)
        {
            using var sha256 = SHA256.Create();
            var bytes = Encoding.UTF8.GetBytes(password);
            var hash = sha256.ComputeHash(bytes);
            return Convert.ToBase64String(hash);
        }
    }
}
EOL

echo "✅ Setup Common completed! The files have been created in $COMMON_DIR."

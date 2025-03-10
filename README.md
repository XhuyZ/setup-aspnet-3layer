# 🚀 ASP.NET 3-Layer Setup Script

🛠 **This script automatically generates a 3-layer architecture for ASP.NET Core Web API on Linux, macOS, and Windows.**
It sets up the necessary directories, initializes the project, and installs essential packages.

![250310_03h34m59s_screenshot](https://github.com/user-attachments/assets/7bb4723b-86e7-47c8-98ac-b381da53daf6)


---

## 📜 Table of Contents

- [✨ Features](#features)
- [📌 Prerequisites](#prerequisites)
- [🚀 Installation Guide](#installation-guide)
  - [Ubuntu](#ubuntu)
  - [macOS](#macos)
  - [Windows (Using GitBash)](#windows-using-gitbash)
- [🔧 Usage Instructions](#usage-instructions)
- [📚 Project Structure](#project-structure)
- [⚠️ Notes](#notes)
- [📝 License](#license)
- [🤝 Contributing](#contributing)
- [👨‍💻 Author](#author)

---

## ✨ Features

✅ Automatically creates a professional 3-layer project structure:

- 🏷 **API Layer** (Web API project)
- 💠 **BLL Layer** (Business Logic Layer)
- 💾 **DAL Layer** (Data Access Layer)
- 🛠 **Common Layer** (Shared utilities)

✅ Initializes the project using .NET CLI
✅ Configures dependencies between layers
✅ Installs required NuGet packages
✅ Displays a visual progress indicator 🎯

---

## 📌 Prerequisites

Ensure your system has the following tools installed:

- [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) and runtime
- Bash (Required for Linux and Windows when using GitBash)
- [MySQL](https://dev.mysql.com/downloads/) (Set the root password to `12345`, or modify it in line 2055 of the script)

### 🛠 Installing .NET SDK 8 and MySQL

#### Ubuntu

```bash
sudo apt update && sudo apt install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0 mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
```

#### macOS

```bash
brew install dotnet-sdk mysql
brew services start mysql
```

#### Windows (Using GitBash)

1. Download and install [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
2. Download and install [MySQL](https://dev.mysql.com/downloads/installer/)
3. Install [GitBash](https://git-scm.com/downloads) if not already installed

---

## 🚀 Usage Instructions

### 1️⃣ Clone the repository:

```bash
git clone https://github.com/XhuyZ/setup-aspnet-3layer.git
cd setup-aspnet-3layer
```

### 2️⃣ Grant execution permission to the script:

```bash
chmod +x ~/script.sh
```

### 3️⃣ Run the script with your desired project name:

```bash
~/script.sh (Input Your Solution Name)
```

### 4️⃣ Once the setup is complete, start the project:

```bash
./db.sh
cd ~/MyProject/API
dotnet watch run
```

---

## 📚 Project Structure

```
~/MyProject/
│── API/        # Web API project
│── BLL/        # Business Logic Layer
│── DAL/        # Data Access Layer
│── Common/     # Shared utilities
~/script.sh     # Installation script
~/db.sh         # Database setup script
```

---

## ⚠️ Notes

- 🏁 The script provides a visual installation progress 🎯
- 🔐 Ensure the script has execution permission before running
- 🛠 Supports MySQL using `Pomelo.EntityFrameworkCore`
- 📌 Follows standard ASP.NET Core Web API architecture

---

## 📝 License

📚 Open-source under the **MIT License**

---

## 🤝 Contributing

🚀 Contributions are welcome! Feel free to open an **Issue** or submit a **Pull Request**.

---

## 👨‍💻 Author

👉 GitHub: [XhuyZ](https://github.com/XhuyZ)


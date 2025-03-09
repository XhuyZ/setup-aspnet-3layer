# 🚀 Script Cài Đặt ASP.NET 3-Layer
![Uploading image.png…]()

&#x20;&#x20;

🛠 **Script này tự động tạo cấu trúc dự án 3-layer cho ASP.NET Core Web API trên Linux và Windows.**
Nó giúp thiết lập thư mục cần thiết, khởi tạo dự án và cài đặt các package quan trọng.

---

## ✨ Tính Năng

✅ Tạo cấu trúc dự án 3-layer chuyên nghiệp:

- 🏷 **API Layer** (Dự án Web API)
- 💠 **BLL Layer** (Tầng Business Logic)
- 💾 **DAL Layer** (Tầng Truy Cập Dữ Liệu)
- 🛠 **Common Layer** (Thư viện dùng chung)

✅ Tự động khởi tạo dự án bằng lệnh .NET CLI
✅ Cấu hình phụ thuộc giữa các tầng
✅ Cài đặt các gói NuGet cần thiết
✅ Hiển thị tiến trình cài đặt trực quan 🎯

---

## 📌 Yêu Cầu Trước Khi Cài Đặt

🛩 Đảm bảo hệ thống có sẵn các công cụ sau:

- [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) và runtime
- Bash (Trên Linux và Windows khi dùng GitBash)
- [MySQL](https://dev.mysql.com/downloads/) (Nếu sử dụng database này)
- Quyền `chmod` để thực thi script

### 🛠 Hướng Dẫn Cài Đặt .NET SDK 8 và MySQL

#### **Ubuntu**

```bash
sudo apt update && sudo apt install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0 mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
```

#### **macOS**

```bash
brew install dotnet-sdk mysql
brew services start mysql
```

#### **Windows (Dùng GitBash)**

1. Tải và cài đặt [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
2. Tải và cài đặt [MySQL](https://dev.mysql.com/downloads/installer/)
3. Cài [GitBash](https://git-scm.com/downloads) nếu chưa có

---

## 🚀 Hướng Dẫn Sử Dụng

1️⃣ **Tải về hoặc clone script này về máy:**

```bash
git clone https://github.com/XhuyZ/setup-aspnet-3layer.git
cd setup-aspnet-3layer
```

2️⃣ **Cấp quyền thực thi cho script:**

```bash
chmod +x ~/script.sh
```

3️⃣ **Chạy script với tên dự án mong muốn:**

```bash
~/script.sh (Input Your Solution Name)
```

4️⃣ **Sau khi hoàn tất, chạy project:**

```bash
./db.sh
cd ~/MyProject/API
dotnet watch run
```

---

## 📚 Cấu Trúc Dự Án Sau Khi Chạy Script

```
~/MyProject/
│── API/        # Dự án Web API
│── BLL/        # Business Logic Layer
│── DAL/        # Data Access Layer
│── Common/     # Thư viện dùng chung
~/script.sh     # Script cài đặt
~/db.sh
```

---

## ⚠️ Ghi Chú

- 🏁 Script có hiển thị tiến trình cài đặt trực quan 🎯
- 🔐 Hãy đảm bảo script có quyền thực thi trước khi chạy
- 🛠 Hỗ trợ MySQL thông qua `Pomelo.EntityFrameworkCore`
- 📌 Cấu trúc dự án tuân theo chuẩn của ASP.NET Core Web API

---

## 📝 Giấy Phép

📚 Mã nguồn mở theo **MIT License**

## 🤝 Đóng Góp

🚀 Mọi đóng góp đều được hoan nghênh! Hãy mở **Issue** hoặc gửi **Pull Request**.

## 👨‍💻 Tác Giả

👉 GitHub: [XhuyZ](https://github.com/XhuyZ)


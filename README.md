# 🚀 Script Cài Đặt ASP.NET 3-Layer

![ASP.NET](https://img.shields.io/badge/ASP.NET-Core-blue?style=flat&logo=dotnet) ![Linux](https://img.shields.io/badge/Linux-Support-green?style=flat&logo=linux) ![MIT License](https://img.shields.io/badge/License-MIT-yellow?style=flat)

🛠 **Script này tự động tạo cấu trúc dự án 3-layer cho ASP.NET Core Web API trên Linux.** 
Nó giúp thiết lập thư mục cần thiết, khởi tạo dự án và cài đặt các package quan trọng.

---

## ✨ Tính Năng
✅ Tạo cấu trúc dự án 3-layer chuyên nghiệp:
- 🏗 **API Layer** (Dự án Web API)
- 🔄 **BLL Layer** (Tầng Business Logic)
- 💾 **DAL Layer** (Tầng Truy Cập Dữ Liệu)
- 🛠 **Common Layer** (Thư viện dùng chung)

✅ Tự động khởi tạo dự án bằng lệnh .NET CLI
✅ Cấu hình phụ thuộc giữa các tầng
✅ Cài đặt các gói NuGet cần thiết
✅ Hiển thị tiến trình cài đặt trực quan 🎯

---

## 📌 Yêu Cầu Trước Khi Cài Đặt
🔹 Đảm bảo hệ thống có sẵn các công cụ sau:
- .NET SDK (Khuyến nghị bản mới nhất)
- Bash (Để chạy script trên Linux)
- Quyền `chmod` để thực thi script

---

## 🚀 Hướng Dẫn Sử Dụng
1️⃣ **Tải về hoặc clone script này về máy:**
   ```bash
   git clone https://github.com/XhuyZ/setup-aspnet-3layer.git
   cd setup-aspnet-3layer
   ```
2️⃣ **Cấp quyền thực thi cho script:**
   ```bash
   chmod +x setup-aspnet-3layer.sh
   ```
3️⃣ **Chạy script với tên dự án mong muốn:**
   ```bash
   ./setup-aspnet-3layer.sh MyProject
   ```
4️⃣ **Sau khi hoàn tất, chạy project:**
   ```bash
   cd MyProject/API
   dotnet run
   ```

---

## 📂 Cấu Trúc Dự Án
```
MyProject/
│── API/        # Dự án Web API
│── BLL/        # Business Logic Layer
│── DAL/        # Data Access Layer
│── Common/     # Thư viện dùng chung
│── setup-aspnet-3layer.sh (Script cài đặt)
```

---

## ⚠️ Ghi Chú
- 🏁 Script có hiển thị tiến trình cài đặt trực quan 🎯
- 🔐 Hãy đảm bảo script có quyền thực thi trước khi chạy
- 🛠 Hỗ trợ MySQL thông qua `Pomelo.EntityFrameworkCore`
- 📌 Cấu trúc dự án tuân theo chuẩn của ASP.NET Core Web API

---

## 📜 Giấy Phép
📖 Mã nguồn mở theo **MIT License**

## 🤝 Đóng Góp
🚀 Mọi đóng góp đều được hoan nghênh! Hãy mở **Issue** hoặc gửi **Pull Request**.

## 👨‍💻 Tác Giả
🔗 GitHub: [XhuyZ](https://github.com/XhuyZ)


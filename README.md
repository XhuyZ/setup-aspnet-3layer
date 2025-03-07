# 🚀 Script Cài Đặt ASP.NET 3-Layer

🛠 **Script này tự động tạo cấu trúc dự án 3-layer cho ASP.NET Core Web API trên Linux.**
Nó giúp thiết lập thư mục cần thiết, khởi tạo dự án và cài đặt các package quan trọng.

---

## ✨ Tính Năng

✅ Tạo cấu trúc dự án 3-layer chuyên nghiệp:

- 🏗 **API Layer** (Dự án Web API)
- 🔄 **BLL Layer** (Tầng Business Logic)
- 💾 **DAL Layer** (Tầng Truy Cập Dữ Liệu)
- 🛠 **Common Layer** (Thư viện dùng chung)

✅ Tự động khởi tạo dự án bằng lệnh .NET CLI\
✅ Cấu hình phụ thuộc giữa các tầng\
✅ Cài đặt các gói NuGet cần thiết\
✅ Hiển thị tiến trình cài đặt trực quan 🎯\
✅ Hướng dẫn rõ ràng về cách chạy từng script

---

## 📌 Yêu Cầu Trước Khi Cài Đặt

🔹 Đảm bảo hệ thống có sẵn các công cụ sau:

- .NET SDK 8 và runtime
- Bash (Để chạy script trên Linux)
- MySQL (Nếu sử dụng database này)
- Quyền `chmod` để thực thi script

### 🔧 Hướng Dẫn Cài Đặt .NET SDK 8 và MySQL

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

---

## 🚀 Hướng Dẫn Sử Dụng

### **Thứ tự chạy các file script**

1️⃣ **Tải về hoặc clone script này về máy:**

```bash
git clone https://github.com/XhuyZ/setup-aspnet-3layer.git
cd setup-aspnet-3layer
```

2️⃣ **Cấp quyền thực thi cho tất cả các script:**

```bash
chmod +x script.sh setup_DAL.sh setup_Common.sh setup_BLL.sh db.sh
```

3️⃣ **Chạy script cài đặt để khởi tạo dự án:**

```bash
./script.sh (Nhập tên Solution của bạn)
```

4️⃣ **Chạy script để tạo migration trong thư mục DAL:**

```bash
./db.sh
```

5️⃣ **Chạy script để khởi động dự án:**

```bash
./run.sh
```

6️⃣ **Nếu muốn chạy trực tiếp bằng tay, di chuyển vào thư mục API và chạy:**

```bash
cd API
dotnet watch run
```

---

## 📂 Cấu Trúc Dự Án Sau Khi Chạy Script

```
~/MyProject/
│── API/        
│── BLL/       
│── DAL/       
│── Common/     
~/script.sh    
~/setup_DAL.sh
~/setup_Common.sh
~/setup_BLL.sh
~/db.sh
~/setup_API.sh
~/run.sh
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


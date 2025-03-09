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
cd ..
cd ..
# Run setup scripts for DAL, BLL, and Common
log_message "Running additional setup scripts..."
# Ensure scripts have execute permissions
chmod +x setup_DAL.sh setup_BLL.sh setup_Common.sh
# Execute scripts
# ./setup_DAL.sh
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAL_DIR=$(find "$BASE_DIR" -maxdepth 2 -type d -name "DAL" | head -n 1)
if [ -z "$DAL_DIR" ]; then
  echo "❌ Could not find the DAL/ directory. Please run script.sh first!"
  exit 1
fi
echo "✅ Found the DAL/ directory at: $DAL_DIR"
ENTITIES_DIR="$DAL_DIR/Entities"
CONFIG_DIR="$DAL_DIR/Configuration"
REPO_INTERFACE_DIR="$DAL_DIR/Repositories/Interfaces"
REPO_IMPL_DIR="$DAL_DIR/Repositories/Implementations"
CONTEXT_DIR="$DAL_DIR/Context"
mkdir -p "$ENTITIES_DIR" "$CONFIG_DIR" "$REPO_INTERFACE_DIR" "$REPO_IMPL_DIR" "$CONTEXT_DIR"
cat >"$ENTITIES_DIR/Item.cs" <<EOL
namespace DAL.Entities
{
    public class Item
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int CategoryId { get; set; }
        public Category Category { get; set; } = null!;
        public ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();
    }
}
EOL
cat >"$ENTITIES_DIR/Category.cs" <<EOL
namespace DAL.Entities
{
    public class Category
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public ICollection<Item> Items { get; set; } = new List<Item>();
    }
}
EOL
cat >"$ENTITIES_DIR/User.cs" <<EOL
using System;
using System.Collections.Generic;

namespace DAL.Entities
{
    public class User
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string PasswordHash { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? LastLogin { get; set; }
        public bool IsActive { get; set; } = true;
        public ICollection<Order> Orders { get; set; } = new List<Order>();
    }
}
EOL
cat >"$ENTITIES_DIR/Order.cs" <<EOL
using System;
using System.Collections.Generic;

namespace DAL.Entities
{
    public enum OrderStatus
    {
        Pending,
        Processing,
        Shipped,
        Delivered,
        Cancelled
    }

    public class Order
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public User User { get; set; } = null!;
        public DateTime OrderDate { get; set; } = DateTime.UtcNow;
        public OrderStatus Status { get; set; } = OrderStatus.Pending;
        public decimal TotalAmount { get; set; }
        public string ShippingAddress { get; set; } = string.Empty;
        public ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();
    }
}
EOL
cat >"$ENTITIES_DIR/OrderDetail.cs" <<EOL
namespace DAL.Entities
{
    public class OrderDetail
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public Order Order { get; set; } = null!;
        public int ItemId { get; set; }
        public Item Item { get; set; } = null!;
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
    }
}
EOL
cat >"$CONFIG_DIR/ItemConfiguration.cs" <<EOL
using DAL.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace DAL.Configuration
{
    public class ItemConfiguration : IEntityTypeConfiguration<Item>
    {
        public void Configure(EntityTypeBuilder<Item> builder)
        {
            builder.HasKey(i => i.Id);
            builder.Property(i => i.Name).IsRequired().HasMaxLength(100);
            builder.HasOne(i => i.Category)
                   .WithMany(c => c.Items)
                   .HasForeignKey(i => i.CategoryId);

            // Seed Data
            builder.HasData(
                new Item { Id = 1, Name = "Apple", CategoryId = 1 },
                new Item { Id = 2, Name = "Orange", CategoryId = 1 },
                new Item { Id = 3, Name = "Pudding", CategoryId = 2 }
            );
        }
    }
}
EOL
cat >"$CONFIG_DIR/CategoryConfiguration.cs" <<EOL
using DAL.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace DAL.Configuration
{
    public class CategoryConfiguration : IEntityTypeConfiguration<Category>
    {
        public void Configure(EntityTypeBuilder<Category> builder)
        {
            builder.HasKey(c => c.Id);
            builder.Property(c => c.Name).IsRequired().HasMaxLength(50);

            // Seed Data
            builder.HasData(
                new Category { Id = 1, Name = "Fruit" },
                new Category { Id = 2, Name = "Cake" }
            );
        }
    }
}
EOL
cat >"$CONFIG_DIR/UserConfiguration.cs" <<EOL
using DAL.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace DAL.Configuration
{
    public class UserConfiguration : IEntityTypeConfiguration<User>
    {
        public void Configure(EntityTypeBuilder<User> builder)
        {
            builder.HasKey(u => u.Id);
            builder.Property(u => u.Username).IsRequired().HasMaxLength(50);
            builder.Property(u => u.Email).IsRequired().HasMaxLength(100);
            builder.Property(u => u.PasswordHash).IsRequired();
            builder.Property(u => u.CreatedAt).IsRequired();
            builder.Property(u => u.IsActive).IsRequired();

            // Seed Data
            builder.HasData(
                new User 
                { 
                    Id = 1, 
                    Username = "admin", 
                    Email = "admin@example.com", 
                    PasswordHash = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8", // "password" hashed
                    CreatedAt = new DateTime(2024, 1, 1),
                    IsActive = true
                },
                new User 
                { 
                    Id = 2, 
                    Username = "user1", 
                    Email = "user1@example.com", 
                    PasswordHash = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8", // "password" hashed
                    CreatedAt = new DateTime(2024, 1, 2),
                    IsActive = true
                }
            );
        }
    }
}
EOL
cat >"$CONFIG_DIR/OrderConfiguration.cs" <<EOL
using DAL.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;

namespace DAL.Configuration
{
    public class OrderConfiguration : IEntityTypeConfiguration<Order>
    {
        public void Configure(EntityTypeBuilder<Order> builder)
        {
            builder.HasKey(o => o.Id);
            builder.Property(o => o.OrderDate).IsRequired();
            builder.Property(o => o.Status).IsRequired();
            builder.Property(o => o.TotalAmount).IsRequired().HasPrecision(18, 2);
            builder.Property(o => o.ShippingAddress).IsRequired().HasMaxLength(255);
            
            builder.HasOne(o => o.User)
                   .WithMany(u => u.Orders)
                   .HasForeignKey(o => o.UserId)
                   .OnDelete(DeleteBehavior.Restrict);

            // Seed Data
            builder.HasData(
                new Order 
                { 
                    Id = 1, 
                    UserId = 1, 
                    OrderDate = new DateTime(2024, 2, 1), 
                    Status = OrderStatus.Delivered, 
                    TotalAmount = 25.50m,
                    ShippingAddress = "123 Main St, City, Country"
                },
                new Order 
                { 
                    Id = 2, 
                    UserId = 2, 
                    OrderDate = new DateTime(2024, 2, 15), 
                    Status = OrderStatus.Shipped, 
                    TotalAmount = 43.75m,
                    ShippingAddress = "456 Oak Ave, Town, Country"
                }
            );
        }
    }
}
EOL
cat >"$CONFIG_DIR/OrderDetailConfiguration.cs" <<EOL
using DAL.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace DAL.Configuration
{
    public class OrderDetailConfiguration : IEntityTypeConfiguration<OrderDetail>
    {
        public void Configure(EntityTypeBuilder<OrderDetail> builder)
        {
            builder.HasKey(od => od.Id);
            builder.Property(od => od.Quantity).IsRequired();
            builder.Property(od => od.UnitPrice).IsRequired().HasPrecision(18, 2);
            
            builder.HasOne(od => od.Order)
                   .WithMany(o => o.OrderDetails)
                   .HasForeignKey(od => od.OrderId)
                   .OnDelete(DeleteBehavior.Cascade);
                   
            builder.HasOne(od => od.Item)
                   .WithMany(i => i.OrderDetails)
                   .HasForeignKey(od => od.ItemId)
                   .OnDelete(DeleteBehavior.Restrict);

            // Seed Data
            builder.HasData(
                new OrderDetail { Id = 1, OrderId = 1, ItemId = 1, Quantity = 2, UnitPrice = 5.25m },
                new OrderDetail { Id = 2, OrderId = 1, ItemId = 2, Quantity = 3, UnitPrice = 5.00m },
                new OrderDetail { Id = 3, OrderId = 2, ItemId = 3, Quantity = 1, UnitPrice = 8.75m },
                new OrderDetail { Id = 4, OrderId = 2, ItemId = 1, Quantity = 5, UnitPrice = 5.00m },
                new OrderDetail { Id = 5, OrderId = 2, ItemId = 2, Quantity = 2, UnitPrice = 5.00m }
            );
        }
    }
}
EOL
cat >"$CONTEXT_DIR/AppDBContext.cs" <<EOL
using DAL.Entities;
using DAL.Configuration;
using Microsoft.EntityFrameworkCore;

namespace DAL.Context
{
    public class AppDBContext : DbContext
    {
        public AppDBContext(DbContextOptions<AppDBContext> options) : base(options) { }

        public DbSet<Item> Items { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderDetail> OrderDetails { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new ItemConfiguration());
            modelBuilder.ApplyConfiguration(new CategoryConfiguration());
            modelBuilder.ApplyConfiguration(new UserConfiguration());
            modelBuilder.ApplyConfiguration(new OrderConfiguration());
            modelBuilder.ApplyConfiguration(new OrderDetailConfiguration());
            base.OnModelCreating(modelBuilder);
        }
    }
}
EOL
cat >"$CONTEXT_DIR/AppDBContextFactory.cs" <<EOL
using DAL.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
namespace DAL.Context
{
    public class AppDBContextFactory : IDesignTimeDbContextFactory<AppDBContext>
    {
        public AppDBContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<AppDBContext>();
            optionsBuilder.UseMySql(
                "Server=localhost;Database=Testnet;Port=3306;User Id=root;Password=12345;",
                new MySqlServerVersion(new Version(8, 0, 2)) // Replace with your MySQL server version
            );

            return new AppDBContext(optionsBuilder.Options);
        }
    }
}
EOL
cat >"$REPO_INTERFACE_DIR/IItemRepository.cs" <<EOL
using DAL.Entities;

namespace DAL.Repositories.Interfaces
{
    public interface IItemRepository
    {
        Task<IEnumerable<Item>> GetAllAsync();
        Task<Item?> GetByIdAsync(int id);
        Task AddAsync(Item item);
        Task UpdateAsync(Item item);
        Task DeleteAsync(int id);
    }
}
EOL
cat >"$REPO_INTERFACE_DIR/ICategoryRepository.cs" <<EOL
using DAL.Entities;

namespace DAL.Repositories.Interfaces
{
    public interface ICategoryRepository
    {
        Task<IEnumerable<Category>> GetAllAsync();
        Task<Category?> GetByIdAsync(int id);
        Task AddAsync(Category category);
        Task UpdateAsync(Category category);
        Task DeleteAsync(int id);
    }
}
EOL
cat >"$REPO_INTERFACE_DIR/IUserRepository.cs" <<EOL
using DAL.Entities;

namespace DAL.Repositories.Interfaces
{
    public interface IUserRepository
    {
        Task<IEnumerable<User>> GetAllAsync();
        Task<User?> GetByIdAsync(int id);
        Task<User?> GetByUsernameAsync(string username);
        Task<User?> GetByEmailAsync(string email);
        Task AddAsync(User user);
        Task UpdateAsync(User user);
        Task DeleteAsync(int id);
    }
}
EOL
cat >"$REPO_INTERFACE_DIR/IOrderRepository.cs" <<EOL
using DAL.Entities;

namespace DAL.Repositories.Interfaces
{
    public interface IOrderRepository
    {
        Task<IEnumerable<Order>> GetAllAsync();
        Task<IEnumerable<Order>> GetByUserIdAsync(int userId);
        Task<Order?> GetByIdAsync(int id);
        Task<Order?> GetByIdWithDetailsAsync(int id);
        Task AddAsync(Order order);
        Task UpdateAsync(Order order);
        Task UpdateStatusAsync(int id, OrderStatus status);
        Task DeleteAsync(int id);
    }
}
EOL
cat >"$REPO_INTERFACE_DIR/IOrderDetailRepository.cs" <<EOL
using DAL.Entities;

namespace DAL.Repositories.Interfaces
{
    public interface IOrderDetailRepository
    {
        Task<IEnumerable<OrderDetail>> GetAllAsync();
        Task<IEnumerable<OrderDetail>> GetByOrderIdAsync(int orderId);
        Task<OrderDetail?> GetByIdAsync(int id);
        Task AddAsync(OrderDetail orderDetail);
        Task AddRangeAsync(IEnumerable<OrderDetail> orderDetails);
        Task UpdateAsync(OrderDetail orderDetail);
        Task DeleteAsync(int id);
        Task DeleteByOrderIdAsync(int orderId);
    }
}
EOL
cat >"$REPO_IMPL_DIR/ItemRepository.cs" <<EOL
using DAL.Context;
using DAL.Entities;
using DAL.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories.Implementations
{
    public class ItemRepository : IItemRepository
    {
        private readonly AppDBContext _context;

        public ItemRepository(AppDBContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Item>> GetAllAsync()
        {
            return await _context.Items.Include(i => i.Category).ToListAsync();
        }

        public async Task<Item?> GetByIdAsync(int id)
        {
            return await _context.Items.Include(i => i.Category).FirstOrDefaultAsync(i => i.Id == id);
        }

        public async Task AddAsync(Item item)
        {
            _context.Items.Add(item);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Item item)
        {
            _context.Items.Update(item);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var item = await _context.Items.FindAsync(id);
            if (item != null)
            {
                _context.Items.Remove(item);
                await _context.SaveChangesAsync();
            }
        }
    }
}
EOL
cat >"$REPO_IMPL_DIR/CategoryRepository.cs" <<EOL
using DAL.Context;
using DAL.Entities;
using DAL.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories.Implementations
{
    public class CategoryRepository : ICategoryRepository
    {
        private readonly AppDBContext _context;

        public CategoryRepository(AppDBContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Category>> GetAllAsync()
        {
            return await _context.Categories.Include(c => c.Items).ToListAsync();
        }

        public async Task<Category?> GetByIdAsync(int id)
        {
            return await _context.Categories.Include(c => c.Items).FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task AddAsync(Category category)
        {
            _context.Categories.Add(category);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Category category)
        {
            _context.Categories.Update(category);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var category = await _context.Categories.FindAsync(id);
            if (category != null)
            {
                _context.Categories.Remove(category);
                await _context.SaveChangesAsync();
            }
        }
    }
}
EOL
cat >"$REPO_IMPL_DIR/UserRepository.cs" <<EOL
using DAL.Context;
using DAL.Entities;
using DAL.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories.Implementations
{
    public class UserRepository : IUserRepository
    {
        private readonly AppDBContext _context;

        public UserRepository(AppDBContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<User>> GetAllAsync()
        {
            return await _context.Users.ToListAsync();
        }

        public async Task<User?> GetByIdAsync(int id)
        {
            return await _context.Users.FindAsync(id);
        }

        public async Task<User?> GetByUsernameAsync(string username)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Username == username);
        }

        public async Task<User?> GetByEmailAsync(string email)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        }

        public async Task AddAsync(User user)
        {
            _context.Users.Add(user);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(User user)
        {
            _context.Users.Update(user);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user != null)
            {
                _context.Users.Remove(user);
                await _context.SaveChangesAsync();
            }
        }
    }
}
EOL
cat >"$REPO_IMPL_DIR/OrderRepository.cs" <<EOL
using DAL.Context;
using DAL.Entities;
using DAL.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories.Implementations
{
    public class OrderRepository : IOrderRepository
    {
        private readonly AppDBContext _context;

        public OrderRepository(AppDBContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Order>> GetAllAsync()
        {
            return await _context.Orders
                .Include(o => o.User)
                .ToListAsync();
        }

        public async Task<IEnumerable<Order>> GetByUserIdAsync(int userId)
        {
            return await _context.Orders
                .Where(o => o.UserId == userId)
                .Include(o => o.User)
                .ToListAsync();
        }

        public async Task<Order?> GetByIdAsync(int id)
        {
            return await _context.Orders
                .Include(o => o.User)
                .FirstOrDefaultAsync(o => o.Id == id);
        }

        public async Task<Order?> GetByIdWithDetailsAsync(int id)
        {
            return await _context.Orders
                .Include(o => o.User)
                .Include(o => o.OrderDetails)
                    .ThenInclude(od => od.Item)
                        .ThenInclude(i => i.Category)
                .FirstOrDefaultAsync(o => o.Id == id);
        }

        public async Task AddAsync(Order order)
        {
            _context.Orders.Add(order);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Order order)
        {
            _context.Orders.Update(order);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateStatusAsync(int id, OrderStatus status)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order != null)
            {
                order.Status = status;
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteAsync(int id)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order != null)
            {
                _context.Orders.Remove(order);
                await _context.SaveChangesAsync();
            }
        }
    }
}
EOL
cat >"$REPO_IMPL_DIR/OrderDetailRepository.cs" <<EOL
using DAL.Context;
using DAL.Entities;
using DAL.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace DAL.Repositories.Implementations
{
    public class OrderDetailRepository : IOrderDetailRepository
    {
        private readonly AppDBContext _context;

        public OrderDetailRepository(AppDBContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<OrderDetail>> GetAllAsync()
        {
            return await _context.OrderDetails
                .Include(od => od.Order)
                .Include(od => od.Item)
                .ToListAsync();
        }

        public async Task<IEnumerable<OrderDetail>> GetByOrderIdAsync(int orderId)
        {
            return await _context.OrderDetails
                .Where(od => od.OrderId == orderId)
                .Include(od => od.Item)
                .ToListAsync();
        }

        public async Task<OrderDetail?> GetByIdAsync(int id)
        {
            return await _context.OrderDetails
                .Include(od => od.Order)
                .Include(od => od.Item)
                .FirstOrDefaultAsync(od => od.Id == id);
        }

        public async Task AddAsync(OrderDetail orderDetail)
        {
            _context.OrderDetails.Add(orderDetail);
            await _context.SaveChangesAsync();
        }

        public async Task AddRangeAsync(IEnumerable<OrderDetail> orderDetails)
        {
            _context.OrderDetails.AddRange(orderDetails);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(OrderDetail orderDetail)
        {
            _context.OrderDetails.Update(orderDetail);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var orderDetail = await _context.OrderDetails.FindAsync(id);
            if (orderDetail != null)
            {
                _context.OrderDetails.Remove(orderDetail);
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteByOrderIdAsync(int orderId)
        {
            var orderDetails = await _context.OrderDetails
                .Where(od => od.OrderId == orderId)
                .ToListAsync();
                
            if (orderDetails.Any())
            {
                _context.OrderDetails.RemoveRange(orderDetails);
                await _context.SaveChangesAsync();
            }
        }
    }
}
EOL

echo "✅ Setup DAL completed! The files have been created in $DAL_DIR."
# ./setup_BLL.sh
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLL_DIR=$(find "$BASE_DIR" -maxdepth 2 -type d -name "BLL" | head -n 1)
if [ -z "$BLL_DIR" ]; then
  echo "❌ Could not find the BLL/ directory. Please run script.sh first!"
  exit 1
fi
echo "✅ Found the BLL/ directory at: $BLL_DIR"

# Create directories
DTOS_DIR="$BLL_DIR/DTOs"
SERVICES_DIR="$BLL_DIR/Services"
EXCEPTIONS_DIR="$BLL_DIR/Exceptions"
INTERFACES_DIR="$BLL_DIR/Interfaces"
MAPPERS_DIR="$BLL_DIR/Mappers"
mkdir -p "$DTOS_DIR" "$SERVICES_DIR" "$EXCEPTIONS_DIR" "$INTERFACES_DIR" "$MAPPERS_DIR"

# Create single AutoMapperProfile
cat >"$MAPPERS_DIR/AutoMapperProfile.cs" <<EOL
using AutoMapper;
using BLL.DTOs;
using DAL.Entities;

namespace BLL.Mappers
{
    public class AutoMapperProfile : Profile
    {
        public AutoMapperProfile()
        {
            CreateMap<Item, ItemDTO>().ReverseMap();
            
            CreateMap<Category, CategoryDTO>().ReverseMap();
            
            CreateMap<User, UserDTO>()
                .ForMember(dest => dest.Orders, opt => opt.MapFrom(src => src.Orders));
            CreateMap<UserDTO, User>();
            
            CreateMap<Order, OrderDTO>()
                .ForMember(dest => dest.Username, opt => opt.MapFrom(src => src.User.Username))
                .ForMember(dest => dest.OrderDetails, opt => opt.MapFrom(src => src.OrderDetails));
            CreateMap<OrderDTO, Order>();
            
            CreateMap<OrderDetail, OrderDetailDTO>()
                .ForMember(dest => dest.ItemName, opt => opt.MapFrom(src => src.Item.Name))
                .ForMember(dest => dest.TotalPrice, opt => opt.MapFrom(src => src.Quantity * src.UnitPrice));
            CreateMap<OrderDetailDTO, OrderDetail>();
        }
    }
}
EOL

# Create service interfaces
cat >"$INTERFACES_DIR/IItemService.cs" <<EOL
using BLL.DTOs;

namespace BLL.Interfaces
{
    public interface IItemService
    {
        Task<IEnumerable<ItemDTO>> GetAllAsync();
        Task<ItemDTO?> GetByIdAsync(int id);
        Task AddAsync(ItemDTO itemDto);
        Task UpdateAsync(ItemDTO itemDto);
        Task DeleteAsync(int id);
    }
}
EOL

cat >"$INTERFACES_DIR/ICategoryService.cs" <<EOL
using BLL.DTOs;

namespace BLL.Interfaces
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryDTO>> GetAllAsync();
        Task<CategoryDTO?> GetByIdAsync(int id);
        Task AddAsync(CategoryDTO categoryDto);
        Task UpdateAsync(CategoryDTO categoryDto);
        Task DeleteAsync(int id);
    }
}
EOL

cat >"$INTERFACES_DIR/IUserService.cs" <<EOL
using BLL.DTOs;

namespace BLL.Interfaces
{
    public interface IUserService
    {
        Task<IEnumerable<UserDTO>> GetAllAsync();
        Task<UserDTO?> GetByIdAsync(int id);
        Task<UserDTO?> GetByUsernameAsync(string username);
        Task<UserDTO?> GetByEmailAsync(string email);
        Task AddAsync(UserDTO userDto);
        Task UpdateAsync(UserDTO userDto);
        Task DeleteAsync(int id);
    }
}
EOL

cat >"$INTERFACES_DIR/IOrderService.cs" <<EOL
using BLL.DTOs;
using DAL.Entities;

namespace BLL.Interfaces
{
    public interface IOrderService
    {
        Task<IEnumerable<OrderDTO>> GetAllAsync();
        Task<IEnumerable<OrderDTO>> GetByUserIdAsync(int userId);
        Task<OrderDTO?> GetByIdAsync(int id);
        Task<OrderDTO?> GetByIdWithDetailsAsync(int id);
        Task<int> CreateOrderAsync(OrderDTO orderDto);
        Task UpdateAsync(OrderDTO orderDto);
        Task UpdateStatusAsync(int id, OrderStatus status);
        Task DeleteAsync(int id);
    }
}
EOL

cat >"$INTERFACES_DIR/IOrderDetailService.cs" <<EOL
using BLL.DTOs;

namespace BLL.Interfaces
{
    public interface IOrderDetailService
    {
        Task<IEnumerable<OrderDetailDTO>> GetAllAsync();
        Task<IEnumerable<OrderDetailDTO>> GetByOrderIdAsync(int orderId);
        Task<OrderDetailDTO?> GetByIdAsync(int id);
        Task AddAsync(OrderDetailDTO orderDetailDto);
        Task AddRangeAsync(IEnumerable<OrderDetailDTO> orderDetailDtos);
        Task UpdateAsync(OrderDetailDTO orderDetailDto);
        Task DeleteAsync(int id);
        Task DeleteByOrderIdAsync(int orderId);
    }
}
EOL

# Create exceptions
cat >"$EXCEPTIONS_DIR/NotFoundException.cs" <<EOL
namespace BLL.Exceptions
{
    public class NotFoundException : Exception
    {
        public NotFoundException() : base() { }
        
        public NotFoundException(string message) : base(message) { }
        
        public NotFoundException(string message, Exception innerException) 
            : base(message, innerException) { }
        
        public NotFoundException(string name, object key)
            : base($"Entity \"{name}\" ({key}) was not found.") { }
    }
}
EOL

cat >"$EXCEPTIONS_DIR/ValidationException.cs" <<EOL
namespace BLL.Exceptions
{
    public class ValidationException : Exception
    {
        public ValidationException() : base() { }
        
        public ValidationException(string message) : base(message) { }
        
        public ValidationException(string message, Exception innerException) 
            : base(message, innerException) { }
    }
}
EOL

cat >"$EXCEPTIONS_DIR/BusinessException.cs" <<EOL
namespace BLL.Exceptions
{
    public class BusinessException : Exception
    {
        public BusinessException() : base() { }
        
        public BusinessException(string message) : base(message) { }
        
        public BusinessException(string message, Exception innerException) 
            : base(message, innerException) { }
    }
}
EOL

# Update services to use AutoMapper
cat >"$SERVICES_DIR/ItemService.cs" <<EOL
using AutoMapper;
using BLL.DTOs;
using BLL.Interfaces;
using DAL.Entities;
using DAL.Repositories.Interfaces;

namespace BLL.Services
{
    public class ItemService : IItemService
    {
        private readonly IItemRepository _itemRepository;
        private readonly IMapper _mapper;

        public ItemService(IItemRepository itemRepository, IMapper mapper)
        {
            _itemRepository = itemRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ItemDTO>> GetAllAsync()
        {
            var items = await _itemRepository.GetAllAsync();
            return _mapper.Map<IEnumerable<ItemDTO>>(items);
        }

        public async Task<ItemDTO?> GetByIdAsync(int id)
        {
            var item = await _itemRepository.GetByIdAsync(id);
            return _mapper.Map<ItemDTO>(item);
        }

        public async Task AddAsync(ItemDTO itemDto)
        {
            var item = _mapper.Map<Item>(itemDto);
            await _itemRepository.AddAsync(item);
        }

        public async Task UpdateAsync(ItemDTO itemDto)
        {
            var item = _mapper.Map<Item>(itemDto);
            await _itemRepository.UpdateAsync(item);
        }

        public async Task DeleteAsync(int id)
        {
            await _itemRepository.DeleteAsync(id);
        }
    }
}
EOL

cat >"$SERVICES_DIR/UserService.cs" <<EOL
using AutoMapper;
using BLL.DTOs;
using BLL.Interfaces;
using DAL.Entities;
using DAL.Repositories.Interfaces;

namespace BLL.Services
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;

        public UserService(IUserRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<UserDTO>> GetAllAsync()
        {
            var users = await _userRepository.GetAllAsync();
            return _mapper.Map<IEnumerable<UserDTO>>(users);
        }

        public async Task<UserDTO?> GetByIdAsync(int id)
        {
            var user = await _userRepository.GetByIdAsync(id);
            return _mapper.Map<UserDTO>(user);
        }

        public async Task<UserDTO?> GetByUsernameAsync(string username)
        {
            var user = await _userRepository.GetByUsernameAsync(username);
            return _mapper.Map<UserDTO>(user);
        }

        public async Task<UserDTO?> GetByEmailAsync(string email)
        {
            var user = await _userRepository.GetByEmailAsync(email);
            return _mapper.Map<UserDTO>(user);
        }

        public async Task AddAsync(UserDTO userDto)
        {
            var user = _mapper.Map<User>(userDto);
            await _userRepository.AddAsync(user);
        }

        public async Task UpdateAsync(UserDTO userDto)
        {
            var user = _mapper.Map<User>(userDto);
            await _userRepository.UpdateAsync(user);
        }

        public async Task DeleteAsync(int id)
        {
            await _userRepository.DeleteAsync(id);
        }
    }
}
EOL

cat >"$SERVICES_DIR/OrderService.cs" <<EOL
using AutoMapper;
using BLL.DTOs;
using BLL.Interfaces;
using DAL.Entities;
using DAL.Repositories.Interfaces;

namespace BLL.Services
{
    public class OrderService : IOrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly IMapper _mapper;

        public OrderService(IOrderRepository orderRepository, IMapper mapper)
        {
            _orderRepository = orderRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<OrderDTO>> GetAllAsync()
        {
            var orders = await _orderRepository.GetAllAsync();
            return _mapper.Map<IEnumerable<OrderDTO>>(orders);
        }

        public async Task<IEnumerable<OrderDTO>> GetByUserIdAsync(int userId)
        {
            var orders = await _orderRepository.GetByUserIdAsync(userId);
            return _mapper.Map<IEnumerable<OrderDTO>>(orders);
        }

        public async Task<OrderDTO?> GetByIdAsync(int id)
        {
            var order = await _orderRepository.GetByIdAsync(id);
            return _mapper.Map<OrderDTO>(order);
        }

        public async Task<OrderDTO?> GetByIdWithDetailsAsync(int id)
        {
            var order = await _orderRepository.GetByIdWithDetailsAsync(id);
            return _mapper.Map<OrderDTO>(order);
        }

        public async Task<int> CreateOrderAsync(OrderDTO orderDto)
        {
            var order = _mapper.Map<Order>(orderDto);
            await _orderRepository.AddAsync(order);
            return order.Id;
        }

        public async Task UpdateAsync(OrderDTO orderDto)
        {
            var order = _mapper.Map<Order>(orderDto);
            await _orderRepository.UpdateAsync(order);
        }

        public async Task UpdateStatusAsync(int id, OrderStatus status)
        {
            await _orderRepository.UpdateStatusAsync(id, status);
        }

        public async Task DeleteAsync(int id)
        {
            await _orderRepository.DeleteAsync(id);
        }
    }
}
EOL

cat >"$SERVICES_DIR/OrderDetailService.cs" <<EOL
using AutoMapper;
using BLL.DTOs;
using BLL.Interfaces;
using DAL.Entities;
using DAL.Repositories.Interfaces;

namespace BLL.Services
{
    public class OrderDetailService : IOrderDetailService
    {
        private readonly IOrderDetailRepository _orderDetailRepository;
        private readonly IMapper _mapper;

        public OrderDetailService(IOrderDetailRepository orderDetailRepository, IMapper mapper)
        {
            _orderDetailRepository = orderDetailRepository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<OrderDetailDTO>> GetAllAsync()
        {
            var orderDetails = await _orderDetailRepository.GetAllAsync();
            return _mapper.Map<IEnumerable<OrderDetailDTO>>(orderDetails);
        }

        public async Task<IEnumerable<OrderDetailDTO>> GetByOrderIdAsync(int orderId)
        {
            var orderDetails = await _orderDetailRepository.GetByOrderIdAsync(orderId);
            return _mapper.Map<IEnumerable<OrderDetailDTO>>(orderDetails);
        }

        public async Task<OrderDetailDTO?> GetByIdAsync(int id)
        {
            var orderDetail = await _orderDetailRepository.GetByIdAsync(id);
            return _mapper.Map<OrderDetailDTO>(orderDetail);
        }

        public async Task AddAsync(OrderDetailDTO orderDetailDto)
        {
            var orderDetail = _mapper.Map<OrderDetail>(orderDetailDto);
            await _orderDetailRepository.AddAsync(orderDetail);
        }

        public async Task AddRangeAsync(IEnumerable<OrderDetailDTO> orderDetailDtos)
        {
            var orderDetails = _mapper.Map<IEnumerable<OrderDetail>>(orderDetailDtos);
            await _orderDetailRepository.AddRangeAsync(orderDetails);
        }

        public async Task UpdateAsync(OrderDetailDTO orderDetailDto)
        {
            var orderDetail = _mapper.Map<OrderDetail>(orderDetailDto);
            await _orderDetailRepository.UpdateAsync(orderDetail);
        }

        public async Task DeleteAsync(int id)
        {
            await _orderDetailRepository.DeleteAsync(id);
        }

        public async Task DeleteByOrderIdAsync(int orderId)
        {
            await _orderDetailRepository.DeleteByOrderIdAsync(orderId);
        }
    }
}
EOL

# Create DTOs
cat >"$DTOS_DIR/ItemDTO.cs" <<EOL
namespace BLL.DTOs
{
    public class ItemDTO
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int CategoryId { get; set; }
        public string CategoryName { get; set; } = string.Empty;
    }
}
EOL

cat >"$DTOS_DIR/CategoryDTO.cs" <<EOL
namespace BLL.DTOs
{
    public class CategoryDTO
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }
}
EOL

cat >"$DTOS_DIR/UserDTO.cs" <<EOL
namespace BLL.DTOs
{
    public class UserDTO
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public DateTime? LastLogin { get; set; }
        public bool IsActive { get; set; }
        public ICollection<OrderDTO> Orders { get; set; } = new List<OrderDTO>();
    }
}
EOL

cat >"$DTOS_DIR/OrderDTO.cs" <<EOL
using DAL.Entities;

namespace BLL.DTOs
{
    public class OrderDTO
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string Username { get; set; } = string.Empty;
        public DateTime OrderDate { get; set; }
        public OrderStatus Status { get; set; }
        public decimal TotalAmount { get; set; }
        public string ShippingAddress { get; set; } = string.Empty;
        public ICollection<OrderDetailDTO> OrderDetails { get; set; } = new List<OrderDetailDTO>();
    }
}
EOL

cat >"$DTOS_DIR/OrderDetailDTO.cs" <<EOL
namespace BLL.DTOs
{
    public class OrderDetailDTO
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public int ItemId { get; set; }
        public string ItemName { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal TotalPrice { get; set; }
    }
}
EOL

# Create interfaces and exceptions (same as before)
# ... (keep the existing interface and exception files)

echo "✅ Setup BLL completed! The files have been created in $BLL_DIR."
# ./setup_Common.sh
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
# ./setup_API.sh
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
API_DIR=$(find "$BASE_DIR" -maxdepth 2 -type d -name "API" | head -n 1)
if [ -z "$API_DIR" ]; then
  echo "❌ Could not find the API/ directory. Please run script.sh first!"
  exit 1
fi
echo "✅ Found the API/ directory at: $API_DIR"

# Create directories
CONTROLLERS_DIR="$API_DIR/Controllers"
MODELS_DIR="$API_DIR/Models"
MIDDLEWARE_DIR="$API_DIR/Middleware"
mkdir -p "$CONTROLLERS_DIR" "$MODELS_DIR" "$MIDDLEWARE_DIR"

# Create controllers
cat >"$CONTROLLERS_DIR/ItemController.cs" <<EOL
using Microsoft.AspNetCore.Mvc;
using BLL.Interfaces;
using BLL.DTOs;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ItemController : ControllerBase
    {
        private readonly IItemService _itemService;

        public ItemController(IItemService itemService)
        {
            _itemService = itemService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ItemDTO>>> GetAll()
        {
            var items = await _itemService.GetAllAsync();
            return Ok(items);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ItemDTO>> GetById(int id)
        {
            var item = await _itemService.GetByIdAsync(id);
            if (item == null) return NotFound();
            return Ok(item);
        }

        [HttpPost]
        public async Task<ActionResult> Create([FromBody] ItemDTO itemDto)
        {
            await _itemService.AddAsync(itemDto);
            return CreatedAtAction(nameof(GetById), new { id = itemDto.Id }, itemDto);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> Update(int id, [FromBody] ItemDTO itemDto)
        {
            if (id != itemDto.Id) return BadRequest();
            await _itemService.UpdateAsync(itemDto);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _itemService.DeleteAsync(id);
            return NoContent();
        }
    }
}
EOL

cat >"$CONTROLLERS_DIR/CategoryController.cs" <<EOL
using Microsoft.AspNetCore.Mvc;
using BLL.Interfaces;
using BLL.DTOs;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CategoryController : ControllerBase
    {
        private readonly ICategoryService _categoryService;

        public CategoryController(ICategoryService categoryService)
        {
            _categoryService = categoryService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CategoryDTO>>> GetAll()
        {
            var categories = await _categoryService.GetAllAsync();
            return Ok(categories);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<CategoryDTO>> GetById(int id)
        {
            var category = await _categoryService.GetByIdAsync(id);
            if (category == null) return NotFound();
            return Ok(category);
        }

        [HttpPost]
        public async Task<ActionResult> Create([FromBody] CategoryDTO categoryDto)
        {
            await _categoryService.AddAsync(categoryDto);
            return CreatedAtAction(nameof(GetById), new { id = categoryDto.Id }, categoryDto);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> Update(int id, [FromBody] CategoryDTO categoryDto)
        {
            if (id != categoryDto.Id) return BadRequest();
            await _categoryService.UpdateAsync(categoryDto);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _categoryService.DeleteAsync(id);
            return NoContent();
        }
    }
}
EOL

cat >"$CONTROLLERS_DIR/UserController.cs" <<EOL
using Microsoft.AspNetCore.Mvc;
using BLL.Interfaces;
using BLL.DTOs;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;

        public UserController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserDTO>>> GetAll()
        {
            var users = await _userService.GetAllAsync();
            return Ok(users);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserDTO>> GetById(int id)
        {
            var user = await _userService.GetByIdAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }

        [HttpGet("by-username/{username}")]
        public async Task<ActionResult<UserDTO>> GetByUsername(string username)
        {
            var user = await _userService.GetByUsernameAsync(username);
            if (user == null) return NotFound();
            return Ok(user);
        }

        [HttpGet("by-email/{email}")]
        public async Task<ActionResult<UserDTO>> GetByEmail(string email)
        {
            var user = await _userService.GetByEmailAsync(email);
            if (user == null) return NotFound();
            return Ok(user);
        }

        [HttpPost]
        public async Task<ActionResult> Create([FromBody] UserDTO userDto)
        {
            await _userService.AddAsync(userDto);
            return CreatedAtAction(nameof(GetById), new { id = userDto.Id }, userDto);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> Update(int id, [FromBody] UserDTO userDto)
        {
            if (id != userDto.Id) return BadRequest();
            await _userService.UpdateAsync(userDto);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _userService.DeleteAsync(id);
            return NoContent();
        }
    }
}
EOL

cat >"$CONTROLLERS_DIR/OrderController.cs" <<EOL
using Microsoft.AspNetCore.Mvc;
using BLL.Interfaces;
using BLL.DTOs;
using DAL.Entities;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OrderController : ControllerBase
    {
        private readonly IOrderService _orderService;

        public OrderController(IOrderService orderService)
        {
            _orderService = orderService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<OrderDTO>>> GetAll()
        {
            var orders = await _orderService.GetAllAsync();
            return Ok(orders);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<OrderDTO>> GetById(int id)
        {
            var order = await _orderService.GetByIdAsync(id);
            if (order == null) return NotFound();
            return Ok(order);
        }

        [HttpGet("{id}/details")]
        public async Task<ActionResult<OrderDTO>> GetByIdWithDetails(int id)
        {
            var order = await _orderService.GetByIdWithDetailsAsync(id);
            if (order == null) return NotFound();
            return Ok(order);
        }

        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<OrderDTO>>> GetByUserId(int userId)
        {
            var orders = await _orderService.GetByUserIdAsync(userId);
            return Ok(orders);
        }

        [HttpPost]
        public async Task<ActionResult<int>> Create([FromBody] OrderDTO orderDto)
        {
            var orderId = await _orderService.CreateOrderAsync(orderDto);
            return CreatedAtAction(nameof(GetById), new { id = orderId }, orderId);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> Update(int id, [FromBody] OrderDTO orderDto)
        {
            if (id != orderDto.Id) return BadRequest();
            await _orderService.UpdateAsync(orderDto);
            return NoContent();
        }

        [HttpPatch("{id}/status")]
        public async Task<ActionResult> UpdateStatus(int id, [FromBody] OrderStatus status)
        {
            await _orderService.UpdateStatusAsync(id, status);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _orderService.DeleteAsync(id);
            return NoContent();
        }
    }
}
EOL

cat >"$CONTROLLERS_DIR/OrderDetailController.cs" <<EOL
using Microsoft.AspNetCore.Mvc;
using BLL.Interfaces;
using BLL.DTOs;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OrderDetailController : ControllerBase
    {
        private readonly IOrderDetailService _orderDetailService;

        public OrderDetailController(IOrderDetailService orderDetailService)
        {
            _orderDetailService = orderDetailService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<OrderDetailDTO>>> GetAll()
        {
            var orderDetails = await _orderDetailService.GetAllAsync();
            return Ok(orderDetails);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<OrderDetailDTO>> GetById(int id)
        {
            var orderDetail = await _orderDetailService.GetByIdAsync(id);
            if (orderDetail == null) return NotFound();
            return Ok(orderDetail);
        }

        [HttpGet("order/{orderId}")]
        public async Task<ActionResult<IEnumerable<OrderDetailDTO>>> GetByOrderId(int orderId)
        {
            var orderDetails = await _orderDetailService.GetByOrderIdAsync(orderId);
            return Ok(orderDetails);
        }

        [HttpPost]
        public async Task<ActionResult> Create([FromBody] OrderDetailDTO orderDetailDto)
        {
            await _orderDetailService.AddAsync(orderDetailDto);
            return CreatedAtAction(nameof(GetById), new { id = orderDetailDto.Id }, orderDetailDto);
        }

        [HttpPost("range")]
        public async Task<ActionResult> CreateRange([FromBody] IEnumerable<OrderDetailDTO> orderDetailDtos)
        {
            await _orderDetailService.AddRangeAsync(orderDetailDtos);
            return Ok();
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> Update(int id, [FromBody] OrderDetailDTO orderDetailDto)
        {
            if (id != orderDetailDto.Id) return BadRequest();
            await _orderDetailService.UpdateAsync(orderDetailDto);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _orderDetailService.DeleteAsync(id);
            return NoContent();
        }

        [HttpDelete("order/{orderId}")]
        public async Task<ActionResult> DeleteByOrderId(int orderId)
        {
            await _orderDetailService.DeleteByOrderIdAsync(orderId);
            return NoContent();
        }
    }
}
EOL

# Create error handling middleware
cat >"$MIDDLEWARE_DIR/ErrorHandlingMiddleware.cs" <<EOL
using System.Net;
using System.Text.Json;
using BLL.Exceptions;

namespace API.Middleware
{
    public class ErrorHandlingMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ErrorHandlingMiddleware> _logger;

        public ErrorHandlingMiddleware(RequestDelegate next, ILogger<ErrorHandlingMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception error)
            {
                var response = context.Response;
                response.ContentType = "application/json";

                response.StatusCode = error switch
                {
                    NotFoundException => (int)HttpStatusCode.NotFound,
                    ValidationException => (int)HttpStatusCode.BadRequest,
                    _ => (int)HttpStatusCode.InternalServerError,
                };

                var result = JsonSerializer.Serialize(new { message = error?.Message });
                await response.WriteAsync(result);
            }
        }
    }
}
EOL

# Create Program.cs with service registration
cat >"$API_DIR/Program.cs" <<EOL
using API.Middleware;
using BLL.Interfaces;
using BLL.Services;
using BLL.Mappers;
using DAL.Context;
using DAL.Repositories.Implementations;
using DAL.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register AutoMapper
builder.Services.AddAutoMapper(typeof(AutoMapperProfile));

// Register DbContext
builder.Services.AddDbContext<AppDBContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        new MySqlServerVersion(new Version(8, 0, 2))
    )
);

// Register Repositories
builder.Services.AddScoped<IItemRepository, ItemRepository>();
builder.Services.AddScoped<ICategoryRepository, CategoryRepository>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IOrderRepository, OrderRepository>();
builder.Services.AddScoped<IOrderDetailRepository, OrderDetailRepository>();

// Register Services
builder.Services.AddScoped<IItemService, ItemService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddScoped<IOrderDetailService, OrderDetailService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseMiddleware<ErrorHandlingMiddleware>();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
EOL

# Create appsettings.json
cat >"$API_DIR/appsettings.json" <<EOL
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=Testnet;Port=3306;User Id=root;Password=12345;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
EOL

echo "✅ Setup API completed! The files have been created in $API_DIR."
# ./db.sh
# cd $PROJECT_NAME/API
# dotnet watch run

log_message "All setup scripts completed successfully!"
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

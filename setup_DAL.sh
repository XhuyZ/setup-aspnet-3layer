#!/bin/bash
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

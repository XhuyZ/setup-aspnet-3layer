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
                new Item { Id = 1, Name = "Paracetamol", CategoryId = 1 },
                new Item { Id = 2, Name = "Aspirin", CategoryId = 1 },
                new Item { Id = 3, Name = "Vitamin C", CategoryId = 2 }
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
                new Category { Id = 1, Name = "Medicine" },
                new Category { Id = 2, Name = "Supplement" }
            );
        }
    }
}
EOL
cat >"$CONTEXT_DIR/AppDBContext.cs" <<EOL
using DAL.Entities;
using Microsoft.EntityFrameworkCore;

namespace DAL.Context
{
    public class AppDBContext : DbContext
    {
        public AppDBContext(DbContextOptions<AppDBContext> options) : base(options) { }

        public DbSet<Item> Items { get; set; }
        public DbSet<Category> Categories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new DAL.Configuration.ItemConfiguration());
            modelBuilder.ApplyConfiguration(new DAL.Configuration.CategoryConfiguration());
            base.OnModelCreating(modelBuilder);
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

echo "✅ Setup DAL completed! The files have been created in $DAL_DIR."

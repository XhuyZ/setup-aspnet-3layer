#!/bin/bash
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLL_DIR=$(find "$BASE_DIR" -maxdepth 2 -type d -name "BLL" | head -n 1)
if [ -z "$BLL_DIR" ]; then
  echo "❌ Could not find the BLL/ directory. Please run script.sh first!"
  exit 1
fi
echo "✅ Found the BLL/ directory at: $BLL_DIR"
DTOS_DIR="$BLL_DIR/DTOs"
SERVICES_DIR="$BLL_DIR/Services"
EXCEPTIONS_DIR="$BLL_DIR/Exceptions"
INTERFACES_DIR="$BLL_DIR/Interfaces"
MAPPERS_DIR="$BLL_DIR/Mappers"
mkdir -p "$DTOS_DIR" "$SERVICES_DIR" "$EXCEPTIONS_DIR" "$INTERFACES_DIR" "$MAPPERS_DIR"
cat >"$DTOS_DIR/ItemDTO.cs" <<EOL
namespace BLL.DTOs
{
    public class ItemDTO
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public int CategoryId { get; set; }
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
cat >"$SERVICES_DIR/ItemService.cs" <<EOL
using BLL.DTOs;
using BLL.Interfaces;
using DAL.Entities;
using DAL.Repositories.Interfaces;

namespace BLL.Services
{
    public class ItemService : IItemService
    {
        private readonly IItemRepository _itemRepository;

        public ItemService(IItemRepository itemRepository)
        {
            _itemRepository = itemRepository;
        }

        public async Task<IEnumerable<ItemDTO>> GetAllAsync()
        {
            var items = await _itemRepository.GetAllAsync();
            return items.Select(i => new ItemDTO { Id = i.Id, Name = i.Name, CategoryId = i.CategoryId });
        }

        public async Task<ItemDTO?> GetByIdAsync(int id)
        {
            var item = await _itemRepository.GetByIdAsync(id);
            return item != null ? new ItemDTO { Id = item.Id, Name = item.Name, CategoryId = item.CategoryId } : null;
        }

        public async Task AddAsync(ItemDTO itemDto)
        {
            var item = new Item { Name = itemDto.Name, CategoryId = itemDto.CategoryId };
            await _itemRepository.AddAsync(item);
        }

        public async Task UpdateAsync(ItemDTO itemDto)
        {
            var item = new Item { Id = itemDto.Id, Name = itemDto.Name, CategoryId = itemDto.CategoryId };
            await _itemRepository.UpdateAsync(item);
        }

        public async Task DeleteAsync(int id)
        {
            await _itemRepository.DeleteAsync(id);
        }
    }
}
EOL
cat >"$SERVICES_DIR/CategoryService.cs" <<EOL
using BLL.DTOs;
using BLL.Interfaces;
using DAL.Entities;
using DAL.Repositories.Interfaces;

namespace BLL.Services
{
    public class CategoryService : ICategoryService
    {
        private readonly ICategoryRepository _categoryRepository;

        public CategoryService(ICategoryRepository categoryRepository)
        {
            _categoryRepository = categoryRepository;
        }

        public async Task<IEnumerable<CategoryDTO>> GetAllAsync()
        {
            var categories = await _categoryRepository.GetAllAsync();
            return categories.Select(c => new CategoryDTO { Id = c.Id, Name = c.Name });
        }

        public async Task<CategoryDTO?> GetByIdAsync(int id)
        {
            var category = await _categoryRepository.GetByIdAsync(id);
            return category != null ? new CategoryDTO { Id = category.Id, Name = category.Name } : null;
        }

        public async Task AddAsync(CategoryDTO categoryDto)
        {
            var category = new Category { Name = categoryDto.Name };
            await _categoryRepository.AddAsync(category);
        }

        public async Task UpdateAsync(CategoryDTO categoryDto)
        {
            var category = new Category { Id = categoryDto.Id, Name = categoryDto.Name };
            await _categoryRepository.UpdateAsync(category);
        }

        public async Task DeleteAsync(int id)
        {
            await _categoryRepository.DeleteAsync(id);
        }
    }
}
EOL
cat >"$EXCEPTIONS_DIR/NotFoundException.cs" <<EOL
namespace BLL.Exceptions
{
    public class NotFoundException : Exception
    {
        public NotFoundException(string message) : base(message) { }
    }
}
EOL
cat >"$MAPPERS_DIR/ItemMapper.cs" <<EOL
using BLL.DTOs;
using DAL.Entities;

namespace BLL.Mappers
{
    public static class ItemMapper
    {
        public static ItemDTO ToDTO(this Item item) =>
            new ItemDTO { Id = item.Id, Name = item.Name, CategoryId = item.CategoryId };

        public static Item ToEntity(this ItemDTO itemDto) =>
            new Item { Id = itemDto.Id, Name = itemDto.Name, CategoryId = itemDto.CategoryId };
    }
}
EOL
cat >"$MAPPERS_DIR/CategoryMapper.cs" <<EOL
using BLL.DTOs;
using DAL.Entities;

namespace BLL.Mappers
{
    public static class CategoryMapper
    {
        public static CategoryDTO ToDTO(this Category category) =>
            new CategoryDTO { Id = category.Id, Name = category.Name };

        public static Category ToEntity(this CategoryDTO categoryDto) =>
            new Category { Id = categoryDto.Id, Name = categoryDto.Name };
    }
}
EOL

echo "✅ Setup BLL completed! The files have been created in $BLL_DIR."

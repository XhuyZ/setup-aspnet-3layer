#!/bin/bash
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

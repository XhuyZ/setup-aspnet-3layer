#!/bin/bash
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

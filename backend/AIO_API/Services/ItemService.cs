using AIO_API.Entities;
using AIO_API.Entities.Items;
using AIO_API.Exceptions;
using AIO_API.Interfaces;
using AIO_API.Models.ItemDto;
using AutoMapper;
using Humanizer;

namespace AIO_API.Services
{
    public class ItemService : IItemService
    {
        private readonly AieDbContext _dbContext;
        private readonly IMapper _mapper;
        private readonly ILogger<ItemService> _logger;

        public ItemService(AieDbContext dbContext, IMapper mapper, ILogger<ItemService> logger)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            _logger = logger;
        }

        public IEnumerable<ItemDto> GetAll()
        {
            var items = _dbContext.Items.ToList();
            var result = _mapper.Map<List<ItemDto>>(items);
            return result;
        }

        public ItemDto GetById(int id)
        {
            var item = _dbContext.Items
                            .Where(i => i.Id == id)
                            .FirstOrDefault();
            if (item == null)
            {
                throw new NotFoundException("Item not found");
            }

            var result = _mapper.Map<ItemDto>(item);

            return result;
        }

        public int Create(CreateItemDto dto)
        {
            var itemExists = _dbContext.Items
                                    .Any(i => i.Name.ToLower() == dto.Name.ToLower());
            if (itemExists)
            {
                throw new BadRequestException("Item with the same name already exists");
            }

            var itemEntity = _mapper.Map<Item>(dto);
            _dbContext.Items.Add(itemEntity);
            _dbContext.SaveChanges();
            return itemEntity.Id;
        }

        public void Update(int id, UpdateItemDto itemDto)
        {
            var item = _dbContext.Items
                            .Where(i => i.Id == id)
                            .FirstOrDefault();
            if (item == null)
            {
                throw new NotFoundException("Item not found");
            }
            _dbContext.Entry(item).CurrentValues.SetValues(itemDto);
            _dbContext.SaveChanges();

        }
    }
}

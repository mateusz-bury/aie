using AIO_API.Models.CharacterDto;
using AIO_API.Models.ItemDto;

namespace AIO_API.Interfaces
{
    public interface IItemService
    {
        public IEnumerable<ItemDto> GetAll();
        public ItemDto GetById(int id);
        public int Create(CreateItemDto dto);
        public void Update(int id, UpdateItemDto itemDto);

    }
}

using AIO_API.Entities.Characters;
using AIO_API.Entities.Items;
using AIO_API.Entities.Users;
using AIO_API.Interfaces;
using AIO_API.Models.CharacterDto;
using AIO_API.Models.ItemDto;
using AIO_API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{
    [ApiController]
    [Authorize]
    [Route("api/item")]
    public class ItemController : ControllerBase
    {
        private readonly IItemService _ItemService;

        public ItemController(IItemService ItemService)
        {
            _ItemService = ItemService;
        }

        [HttpGet]
        public ActionResult<IEnumerable<ItemDto>> GetAll()
        {
            var items = _ItemService.GetAll();
            return Ok(items);
        }

        [HttpGet("{id}")]
        public ActionResult<ItemDto> GetById([FromRoute] int id)
        {
            var item = _ItemService.GetById(id);
            return Ok(item);
        }

        [HttpPost]
        public ActionResult<Item> Create([FromBody] CreateItemDto dto)
        {
            var itemId = _ItemService.Create(dto);
            return Created($"api/item/{itemId}", null);
        }

        [HttpPut("{id}")]
        public ActionResult Update([FromRoute] int id, [FromBody] UpdateItemDto dto)
        {
            _ItemService.Update(id, dto);
            return Ok();
        }


    }
}

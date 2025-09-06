using AIO_API.Data;
using AIO_API.Entities;
using AIO_API.Entities.Items;
using AIO_API.Models.EquipementDto;
using AIO_API.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AIO_API.Controllers
{
    [Route("api/character/{characterid}/item")]
    [ApiController]
    public class CharacterItemController : ControllerBase
    {
        private readonly ICharacterItemService _characterItemService;

        public CharacterItemController(ICharacterItemService characterItemService)
        {
            _characterItemService = characterItemService;
        }

        [HttpPost]
        public ActionResult Post([FromRoute] int characterId, [FromBody] CreateCharacterItemDto dto)
        {
            var itemId = _characterItemService.Create(characterId, dto);
            return Created($"api/character/{characterId}/item/{itemId}", null);
        }


        [HttpGet("{itemId}")]
        public ActionResult<CharacterItemDto> Get([FromRoute] int characterId, [FromRoute] int itemId)
        {
            CharacterItemDto characterItem = _characterItemService.GetById(characterId,itemId);
            return Ok(characterItem);
        }

        [HttpGet]
        public ActionResult<List<CharacterItemDto>> GetAll([FromRoute] int characterId)
        {
            List<CharacterItemDto> result = _characterItemService.GetAll(characterId);
            return result;
        }


        [HttpDelete("{itemId}")]
        public ActionResult<CharacterItemDto> Delete([FromRoute] int characterId, [FromRoute] int itemId)
        {
            _characterItemService.Delete(characterId, itemId);
            return NoContent();
        }

    }
}

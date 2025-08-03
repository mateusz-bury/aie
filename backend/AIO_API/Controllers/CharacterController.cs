using AIO_API.Data;
using AIO_API.Entities;
using AIO_API.Interfaces;
using AIO_API.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{
    [ApiController]
    [Route("api/character")]
    public class CharacterController : ControllerBase
    {
        private ICharacterService _characterService;

        public CharacterController(ICharacterService characterService)
        {
            _characterService = characterService;
        }

        [HttpPut("{id}")]
        public ActionResult Update([FromRoute]int id, [FromBody] UpdatePlayableCharacterDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var isUpdated = _characterService.Update(id, dto);

            if (isUpdated)
            {
                return Ok();
            }
            return NotFound();
        }



        [HttpDelete("{id}")]
        public ActionResult Delete([FromRoute]int id)
        {
            var isDeleted = _characterService.Delete(id);

            if (isDeleted)
            {
                return NoContent();
            }
            return NotFound();
        }

        [HttpPost]
        public ActionResult CreatePlayableCharacter([FromBody] CreatePlayableCharacterDto dto)
        {
            if (!ModelState.IsValid) 
            { 
                return BadRequest(ModelState);
            }

            var id = _characterService.Create(dto);

            return Created($"/api/character/{id}", null);
        }

        [HttpGet]
        public ActionResult<IEnumerable<PlayableCharacterDto>> GetAll()
        {
            var playableCharactersDto = _characterService.GetAll();

            return Ok(playableCharactersDto);
        }

        [HttpGet("{id}")]
        public ActionResult<PlayableCharacter> Get([FromRoute] int id)
        {
            var playableCharacterByIdDto = _characterService.GetById(id);

            if(playableCharacterByIdDto == null)
            {
                return NotFound();
            }
            return Ok(playableCharacterByIdDto);
        }
    }
}

using AIO_API.Data;
using AIO_API.Entities;
using AIO_API.Interfaces;
using AIO_API.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{
    [Route("api/character")]
    [ApiController]
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
            _characterService.Update(id, dto);
            return Ok();
        }



        [HttpDelete("{id}")]
        public ActionResult Delete([FromRoute]int id)
        {
            _characterService.Delete(id);
            return NoContent();
        }

        [HttpPost]
        public ActionResult CreatePlayableCharacter([FromBody] CreatePlayableCharacterDto dto)
        {

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
            return Ok(playableCharacterByIdDto);
        }
    }
}

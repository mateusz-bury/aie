using AIO_API.Data;
using AIO_API.Entities.Character;
using AIO_API.Interfaces;
using AIO_API.Models.CharacterDto;
using AIO_API.Models.UserDTO;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace AIO_API.Controllers
{
    [Route("api/character")]
    [ApiController]
    public class CharacterController : ControllerBase
    {
        private ICharacterService _characterService;
        private int UserId => int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        public CharacterController(ICharacterService characterService)
        {
            _characterService = characterService;
        }

        [HttpPut("{id}")]
        public ActionResult Update([FromRoute]int id, [FromBody] UpdatePlayableCharacterDto dto)
        {
            _characterService.Update(id, UserId, dto);
            return Ok();
        }



        [HttpDelete("{id}")]
        public ActionResult Delete([FromRoute]int id)
        {
            _characterService.Delete(id);
            return NoContent();
        }

        [HttpPost]
        public ActionResult<PlayableCharacter> CreatePlayableCharacter([FromBody] CreatePlayableCharacterDto dto)
        {
            var playableCharacter = _characterService.Create(UserId,dto);
            return Ok(playableCharacter);
        }

        [HttpGet]
        public ActionResult<IEnumerable<PlayableCharacterDto>> GetAll()
        {
            var playableCharactersDto = _characterService.GetAll(UserId);
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

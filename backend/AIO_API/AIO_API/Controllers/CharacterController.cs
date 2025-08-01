using AIO_API.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CharacterController : ControllerBase
    {
        private ICharacterService _characterService;

        public CharacterController(ICharacterService characterService)
        {
            _characterService = characterService;
        }
        [HttpGet]
        public async Task<IEnumerable<ICharacter>> GetAllCharactersAsync()
        {
            return await _characterService.GetAllCharactersAsync();
        }
    }
}

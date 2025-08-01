using AIO_API.Data;
using AIO_API.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CharacterController : ControllerBase
    {
        private ICharacterService _characterService;
        private readonly AieDbContext _dbContext;

        public CharacterController(ICharacterService characterService, AieDbContext dbContext)
        {
            _characterService = characterService;
            _dbContext = dbContext;
        }
        [HttpGet]
        public async Task<IEnumerable<ICharacter>> GetAllCharactersAsync()
        {
            //return await _characterService.GetAllCharactersAsync();
            var playableCharacters = _dbContext.
                                    PlayableCharacter.
                                    ToList();
            return playableCharacters;
        }
    }
}

using AIO_API.Entities;
using AIO_API.Entities.Character;
using AIO_API.Exceptions;
using AIO_API.Interfaces;
using AIO_API.Migrations;
using AIO_API.Models.CharacterDto;
using AutoMapper;

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Services
{
    public class CharacterService : ICharacterService
    {

        private readonly AieDbContext _dbContext;
        private readonly IMapper _mapper;
        private readonly ILogger<CharacterService> _logger;

        public CharacterService(AieDbContext dbContext, IMapper mapper, ILogger<CharacterService> logger)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            _logger = logger;
        }

        public void Update(int id, UpdatePlayableCharacterDto dto)
        {
            var playableCharacterById = _dbContext
                            .PlayableCharacter
                            .FirstOrDefault(p => p.id == id);

            if (playableCharacterById == null)
                throw new NotFoundException("Character not found");

            playableCharacterById.WeaponSkill = dto.WeaponSkill;

            _dbContext.SaveChanges();
        }

        public void Delete(int id)
        {
            _logger.LogError($"Character with id: {id} DELETE action invoked");

            var playableCharacterById = _dbContext
                            .PlayableCharacter
                            .FirstOrDefault(p => p.id == id);
            if (playableCharacterById == null)
                throw new NotFoundException("Character not found");

            _dbContext.Remove(playableCharacterById);
            _dbContext.SaveChanges();
        }

        public PlayableCharacterDto GetById(int id)
        {
            var playableCharacterById = _dbContext
                            .PlayableCharacter
                            .FirstOrDefault(p => p.id == id);

            if (playableCharacterById == null) 
                throw new NotFoundException("Character not found");

            var result = _mapper.Map<PlayableCharacterDto>(playableCharacterById);

            return result;
        }

        public IEnumerable<PlayableCharacterDto> GetAll()
        {
            var playableCharacters = _dbContext.
                                   PlayableCharacter.
                                   ToList();

            var playableCharactersDto = _mapper.Map<List<PlayableCharacterDto>>(playableCharacters);

            return playableCharactersDto;
        }

        public int Create(CreatePlayableCharacterDto dto)
        {
            var playableCharacter = _mapper.Map<Entities.Character.PlayableCharacter>(dto);
            _dbContext.PlayableCharacter.Add(playableCharacter);
            _dbContext.SaveChanges();

            return playableCharacter.id;
        }
    }
}

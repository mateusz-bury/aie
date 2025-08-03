using AIO_API.Data;
using AIO_API.Entities;
using AIO_API.Interfaces;
using AIO_API.Migrations;
using AIO_API.Models;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Services
{
    public class CharacterService : ICharacterService
    {
        private readonly AieDbContext _dbContext;
        private readonly IMapper _mapper;

        public CharacterService(AieDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        public bool Update(int id, UpdatePlayableCharacterDto dto)
        {
            var playableCharacterById = _dbContext
                            .PlayableCharacter
                            .FirstOrDefault(p => p.id == id);

            if (playableCharacterById == null) return false;

            playableCharacterById.WeaponSkill = dto.WeaponSkill;

            _dbContext.SaveChanges();
            return true;
        }

        public bool Delete(int id)
        {
            var playableCharacterById = _dbContext
                            .PlayableCharacter
                            .FirstOrDefault(p => p.id == id);
            if (playableCharacterById == null) return false;

            _dbContext.Remove(playableCharacterById);
            _dbContext.SaveChanges();
            return true;
        }

        public PlayableCharacterDto GetById(int id)
        {
            var playableCharacterById = _dbContext
                            .PlayableCharacter
                            .FirstOrDefault(p => p.id == id);

            if (playableCharacterById == null) return null;

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
            var playableCharacter = _mapper.Map<PlayableCharacter>(dto);
            _dbContext.PlayableCharacter.Add(playableCharacter);
            _dbContext.SaveChanges();

            return playableCharacter.id;
        }
    }
}

using AIO_API.Entities;
using AIO_API.Entities.Characters;
using AIO_API.Entities.Characters.Abilities;
using AIO_API.Entities.Characters.Skills;
using AIO_API.Entities.Characters.Statistics;
using AIO_API.Entities.Users;
using AIO_API.Exceptions;
using AIO_API.Interfaces;
using AIO_API.Interfaces.Repo;
using AIO_API.Models.CharacterDto;
using AIO_API.Models.CharacterDto.Ability;
using AIO_API.Models.CharacterDto.Skill;
using AIO_API.Models.CharacterDto.Statistic;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Services
{
    public class CharacterService : ICharacterService
    {

        private readonly IMapper _mapper;
        private readonly ILogger<CharacterService> _logger;
        private readonly ICharacterRepository _repo;

        public CharacterService(IMapper mapper, ILogger<CharacterService> logger, ICharacterRepository repo)
        {
            _mapper = mapper;
            _logger = logger;
            _repo = repo;
        }

        public void Update(int id, int userId, UpdateCharacterDto dto)
        {
            var CharacterById = _repo.GetById(id, userId);
            _repo.Update(CharacterById, dto);
            _repo.SaveChanges();
        }
        public void Delete(int id, int userId)
        {
            //_logger.LogError($"Character with id: {id} DELETE action invoked");

            var CharacterById = _repo.GetById(id, userId);
            _repo.Remove(CharacterById);
            _repo.SaveChanges();
        }
        public CharacterDto GetById(int id, int userId)
        {
            var CharacterById = _repo.GetById(id, userId);
            return _mapper.Map<CharacterDto>(CharacterById);
        }
        public IEnumerable<CharacterDto> GetAll(int userId)
        {
            var Characters = _repo.GetAllForUser(userId);
            return _mapper.Map<List<CharacterDto>>(Characters);
        }
        public int Create(int userId, CreateCharacterDto dto)
        {
            Character character = dto.CharacterType switch
            {
                CharacterType.Playable => _mapper.Map<PlayableCharacter>(dto).ApplyUser(userId),
                CharacterType.Npc => _mapper.Map<NpcCharacter>(dto).ApplyUser(userId),
                _ => throw new BadRequestException("Unknown character type")
            };

            character.ValidateStatistics(dto.Statistics);

            foreach (var statDto in dto.Statistics)
            {
                var stat = _mapper.Map<Statistic>(statDto);
                stat.CharacterId = character.id;
                character.Statistics.Add(stat);
            }

            _repo.Add(character);
            _repo.SaveChanges();

            return character.id;
        }
        public void AddSkill(int id, int userId, AddCharacterSkillDto dto)
        {
            var character = _repo.GetById(id, userId);

            foreach (var skillDto in dto.Skills)
            {
                character.AddSkill(skillDto.SkillId);
            }
            _repo.SaveChanges();
        }
        public void DeleteSkill(int id, int userId, DeleteCharacterSkillDto dto)
        {

            var character = _repo.GetById(id, userId);

            foreach (var skillDto in dto.Skills)
            {
                character.DeleteSkill(skillDto.SkillId);
            }
            _repo.SaveChanges();
        }
        public void AddAbility(int id,int userId, AddCharacterAbilityDto dto)
        {
            var character = _repo.GetById(id, userId);

            foreach (var abilityDto in dto.Abilities)
            {
                character.AddAbility(abilityDto.AbilityId);
            }
            _repo.SaveChanges();
        }
        public void DeleteAbility(int id, int userId, DeleteCharacterAbilityDto dto)
        {
            var character = _repo.GetById(id, userId);

            foreach (var abilityDto in dto.Abilities)
            {
                character.DeleteAbility(abilityDto.AbilityId);
            }
            _repo.SaveChanges();
        }
        public void UpdateStatistic(int id, int userId, UpdateStatisticDto dto)
        {
            var character = _repo.GetById(id, userId);
            if(dto.StatisticType == StatisticType.Base)
                throw new BadRequestException("Base statistic cannot be modified");

            var statistic = _mapper.Map<Statistic>(dto);

            character.UpdateStatistic(statistic);

            _repo.SaveChanges();
        }

    }
}

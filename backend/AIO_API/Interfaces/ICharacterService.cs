using AIO_API.Models.CharacterDto;
using AIO_API.Models.CharacterDto.Ability;
using AIO_API.Models.CharacterDto.Skill;
using AIO_API.Models.CharacterDto.Statistic;

namespace AIO_API.Interfaces
{
    public interface ICharacterService
    {

        public CharacterDto GetById(int id, int userId);
        public int Create(int userId,CreateCharacterDto dto);
        public IEnumerable<CharacterDto> GetAll(int userId);
        public void Delete(int id, int userId);
        public void Update(int id,int userId, UpdateCharacterDto dto);
        public void AddSkill(int id, int userId, AddCharacterSkillDto dto);
        public void DeleteSkill(int id, int userId, DeleteCharacterSkillDto dto);
        public void AddAbility(int id, int userId, AddCharacterAbilityDto dto);
        public void DeleteAbility(int id, int userId, DeleteCharacterAbilityDto dto);
        public void UpdateStatistic(int id, int userId, UpdateStatisticDto dto);
        public IEnumerable<SkillDto> GetSkills();
        public IEnumerable<AbilityDto> GetAbilities();
    }
}

using AIO_API.Models.CharacterDto.Skill;

namespace AIO_API.Interfaces
{
    public interface ISkillService
    {
        public IEnumerable<SkillDto> GetSkills();
    }
}

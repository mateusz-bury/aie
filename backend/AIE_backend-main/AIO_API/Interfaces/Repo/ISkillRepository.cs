using AIO_API.Entities.Characters.Skills;
using AIO_API.Models.CharacterDto.Skill;

namespace AIO_API.Interfaces.Repo
{
    public interface ISkillRepository
    {
        IEnumerable<Skill> GetSkills();
    }
}

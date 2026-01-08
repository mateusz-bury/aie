using AIO_API.Entities.Characters.Skills;

namespace AIO_API.Interfaces
{
    public interface ICharacter
    {
        string Name { get; }
        string Race { get; }
        string Career { get; }
        short Age { get; }

        public void AssignToUser(int userId);
        public void AddSkill(int skillId);
        public void DeleteSkill(int skillId);
        public void AddAbility(int skillId);

    }

}

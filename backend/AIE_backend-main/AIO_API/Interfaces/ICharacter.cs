using AIO_API.Entities.Characters.Skills;
using AIO_API.Entities.Characters.Statistics;

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
        public void DeleteAbility(int skillId);
        public void UpdateStatistic(Statistic statistic);
    }

}

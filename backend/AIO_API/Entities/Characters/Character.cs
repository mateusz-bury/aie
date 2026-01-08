using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Characters.Abilities;
using AIO_API.Entities.Characters.Skills;
using AIO_API.Entities.Characters.Statistics;
using AIO_API.Entities.Users;
using AIO_API.Exceptions;
using AIO_API.Interfaces;
using AIO_API.Models.CharacterDto.Skill;
using AIO_API.Models.CharacterDto.Statistic;
using Humanizer;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Entities.Characters
{
    public abstract class Character : ICharacter
    {
        public int id { get; set; }
        public string Name { get; set; }
        public string Race { get; set; }
        public string Career { get; set; }
        public short Age { get; set; }
        public int CampaignId { get; set; }
        public Campaign Campaign { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }
        public ICollection<Statistic> Statistics { get; set; }
         = new List<Statistic>();
        public ICollection<CharacterItem> CharacterItems { get; set; }
            = new List<CharacterItem>();
        public ICollection<CharacterSkill> CharacterSkills { get; set; }
            = new List<CharacterSkill>();
        public ICollection<CharacterAbility> CharacterAbilities { get; set; }
            = new List<CharacterAbility>();

        public void AssignToUser(int userId)
        {
                       UserId = userId;
        }

        public void AddSkill(int skillId)
        {
            if (CharacterSkills.Any(cs => cs.SkillId == skillId))
                throw new DomainException("Character already has this skill");

            CharacterSkills.Add(new CharacterSkill
            {
                SkillId = skillId
            });
        }

        public void DeleteSkill(int skillId)
        {
            var characterSkill = CharacterSkills
                                    .FirstOrDefault(cs => cs.SkillId == skillId);
            if (characterSkill == null)
                throw new DomainException("Character does not have this skill");
            CharacterSkills.Remove(characterSkill);
        }

        public Character ApplyUser(int userId)
        {
            UserId = userId;
            return this;
        }

        public void AddAbility(int abilityId)
        {
            if (CharacterAbilities.Any(cs => cs.AbilityId == abilityId))
                throw new DomainException("Character already has this ability");

            CharacterAbilities.Add(new CharacterAbility
            {
                AbilityId = abilityId
            });
        }

        //public void UpdateStatistic(UpdateStatisticDto dto)
        //{
        //    var statistic = Statistics
        //        .FirstOrDefault(s => s.StatisticType == dto.StatisticType);

        //    if (statistic is null)
        //        throw new DomainException(
        //            $"Statistic type '{dto.StatisticType}' not found for this character");

        //    statistic.UpdateFrom(dto);
        //}

        public void DeleteAbility(int abilityId)
        {
            var characterAbilities = CharacterAbilities
                                    .FirstOrDefault(cs => cs.AbilityId == abilityId);
            if (characterAbilities == null)
                throw new DomainException("Character does not have this ability");
            CharacterAbilities.Remove(characterAbilities);
        }

        public void ValidateStatistics(List<CreateCharacterStatisticDto> stats)
        {
            if (stats.Count != 2)
                throw new BadRequestException("Character must have exactly 2 statistics (Base & Current)");

            if (!stats.Any(s => s.StatisticType == StatisticType.Base))
                throw new BadRequestException("Missing Basic statistics");

            if (!stats.Any(s => s.StatisticType == StatisticType.Current))
                throw new BadRequestException("Missing Current statistics");

            var basic = stats.First(s => s.StatisticType == StatisticType.Base);
            var current = stats.First(s => s.StatisticType == StatisticType.Current);

        }
    }
}

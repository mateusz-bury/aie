using AIO_API.Entities.Characters;
using System.ComponentModel.DataAnnotations;
using AIO_API.Models.CharacterDto.Skill;
using AIO_API.Models.CharacterDto.Ability;
using AIO_API.Models.CharacterDto.Statistic;

namespace AIO_API.Models.CharacterDto
{
    public class CharacterDto
    {
        [Required]
        public CharacterType CharacterType { get; set; }
        public int id { get; set; }
        public string Name { get; set; }
        public string Race { get; set; }
        public string Career { get; set; }
        public short Age { get; set; }
        public int CampaignId { get; set; }

        //public int BallisticSkill { get; set; }
        //public int Strength { get; set; }
        //public int Toughness { get; set; }
        //public int Agility { get; set; }
        //public int Intelligence { get; set; }
        //public int WillPower { get; set; }
        //public int Fellowship { get; set; }

        //public int Attacks { get; set; }
        //public int Wounds { get; set; }
        //public int Movement { get; set; }
        //public int Magic { get; set; }
        //public int InsanityPoints { get; set; }
        //public int FatePoints { get; set; }
        public List<StatisticDto> Statistics { get; set; } 
        public List<SkillDto> Skills { get; set; }
        public List<InventoryDto> Inventory { get; set; }
        public List<AbilityDto> Abilities { get; set; }

    }
}

using System.ComponentModel.DataAnnotations;

namespace AIO_API.Models.CharacterDto
{
    public class UpdateCharacterDto
    {
        [Required]
        [MaxLength(50)]
        public string Name { get; set; }
        [Required]
        [MaxLength(50)]
        public string Race { get; set; }
        [Required]
        [MaxLength(50)]
        public string Career { get; set; }
        [Required]
        public short Age { get; set; }

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


    }
}


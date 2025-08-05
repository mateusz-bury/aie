using System.ComponentModel.DataAnnotations;

namespace AIO_API.Models
{
    public class CreatePlayableCharacterDto
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
        public int WeaponSkill { get; set; }
    }
}

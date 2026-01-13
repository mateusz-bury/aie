using AIO_API.Entities.Characters;
using System.ComponentModel.DataAnnotations;

namespace AIO_API.Models.CharacterDto
{
    public class AllCharacterDto
    {
        [Required]
        public CharacterType CharacterType { get; set; }
        public int id { get; set; }
        public string Name { get; set; }
        public string Race { get; set; }
        public string Career { get; set; }
        public short Age { get; set; }
        public int CampaignId { get; set; }
    }
}

using AIO_API.Entities.Character;
using AIO_API.Entities.Items;
using System.ComponentModel.DataAnnotations;

namespace AIO_API.Models.EquipementDto
{
    public class CreateCharacterItemDto
    {
        [Required]
        public int ItemId { get; set; }
        [Required]
        public int Count { get; set; }
    }
}

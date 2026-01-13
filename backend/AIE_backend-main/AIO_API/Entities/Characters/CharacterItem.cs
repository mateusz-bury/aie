using AIO_API.Entities.Items;
using AIO_API.Interfaces;
using System.ComponentModel.DataAnnotations;

namespace AIO_API.Entities.Characters
{
    public class CharacterItem
    {
        public int CharacterId { get; set; }
        public Character Character { get; set; }
        public int ItemId { get; set; }
        
        public Item Item { get; set; }

        public int Count { get; set; }
    }
}

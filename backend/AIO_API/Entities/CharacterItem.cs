using AIO_API.Interfaces;

namespace AIO_API.Entities
{
    public class CharacterItem
    {
        public int CharacterId { get; set; }
        public PlayableCharacter Character { get; set; }

        public int ItemId { get; set; }
        public Item Item { get; set; }

        public int Count { get; set; }
    }
}

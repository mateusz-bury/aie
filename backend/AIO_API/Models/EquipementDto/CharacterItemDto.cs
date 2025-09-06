namespace AIO_API.Models.EquipementDto
{
    public class CharacterItemDto
    {
        public int CharacterId { get; set; }
        public int ItemId { get; set; }
        public int Count { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Type { get; set; }
        public int Price { get; set; }
        public int Weight { get; set; }
    }
}

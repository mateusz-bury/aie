namespace AIO_API.Models.ItemDto
{
    public class CreateItemDto
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public string Type { get; set; }
        public int Price { get; set; }
        public int Weight { get; set; }
    }
}

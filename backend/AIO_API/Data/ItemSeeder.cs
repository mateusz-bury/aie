using AIO_API.Entities;

namespace AIO_API.Data
{
    public class ItemSeeder
    {
        private readonly AieDbContext _dbContext;

        public ItemSeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Seed()
        {
            if (!_dbContext.Items.Any())
            {
                var items = GetItems();
                _dbContext.Items.AddRange(items);
                _dbContext.SaveChanges();
            }
        }

        private IEnumerable<Item> GetItems()
        {
            var items = new List<Item>()
            {
                new Item()
                {
                    Name = "Miecz",
                    Description = "zwykły miecz",
                    Type = "Broń",
                    Price = 25,
                    Weight = 5
                },
                new Item()
                {
                    Name = "Tarcza",
                    Description = "drewniana tarcza",
                    Type = "Zbroja",
                    Price = 50,
                    Weight = 15
                }
            };

            return items;
        }
    }
}

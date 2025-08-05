using AIO_API.Entities;

namespace AIO_API.Data
{
    public class CharacterItemSeeder
    {
        private readonly AieDbContext _dbContext;

        public CharacterItemSeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Seed()
        {
            if (!_dbContext.CharacterItems.Any())
            {
                var characterItems = GetCharacterItems();
                _dbContext.CharacterItems.AddRange(characterItems);
                _dbContext.SaveChanges();
            }
        }

        private IEnumerable<CharacterItem> GetCharacterItems()
        {
            var characterItems = new List<CharacterItem>()
            {
                new CharacterItem()
                {
                    CharacterId = 1,
                    ItemId = 1,
                    Count = 2
                },
                new CharacterItem()
                {
                    CharacterId = 2,
                    ItemId = 2,
                    Count = 1
                }
            };

            return characterItems;
        }
    }
}

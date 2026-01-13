using AIO_API.Entities;
using AIO_API.Entities.Characters;

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
            var aldred = _dbContext.Characters
                            .First(u => u.Name == "Aldred");
            var meliret = _dbContext.Characters
                            .First(u => u.Name == "Meliret");
            
            var characterItems = new List<CharacterItem>()
            {
                    
                new CharacterItem()
                {
                    CharacterId = aldred.id,
                    ItemId = 1,
                    Count = 2
                },
                new CharacterItem()
                {
                    CharacterId = meliret.id,
                    ItemId = 2,
                    Count = 1
                }
            };

            return characterItems;
        }
    }
}

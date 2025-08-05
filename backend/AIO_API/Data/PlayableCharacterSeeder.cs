using AIO_API.Entities;
using AIO_API.Entities.Character;


namespace AIO_API.Data
{
    public class PlayableCharacterSeeder
    {
        private readonly AieDbContext _dbContext;
        public PlayableCharacterSeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public void Seed()
        {
            if (_dbContext.Database.CanConnect())
            {
                if (!_dbContext.PlayableCharacter.Any())
                {
                    var playableCharacters = GetPlayableCharacters();
                    _dbContext.PlayableCharacter.AddRange(playableCharacters);
                    _dbContext.SaveChanges();
                }
            }
        }

        private IEnumerable<PlayableCharacter> GetPlayableCharacters() 
        {
            var characters = new List<PlayableCharacter>()
            {
                new PlayableCharacter()
                {
                    Name = "Aldred",
                    Race = "Człowiek",
                    Career = "Wojownik",
                    Age = 25
                },
                new PlayableCharacter()
                {
                    Name = "Meliret",
                    Race = "Elf",
                    Career = "Rzecznik Rodu",
                    Age = 150
                }
            };

            return characters;
        }
    }
}

using AIO_API.Entities;
using AIO_API.Entities.Characters.Abilities;

namespace AIO_API.Data
{
    public class AbilitySeeder
    {
        private readonly AieDbContext _dbContext;

        public AbilitySeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Seed()
        {
            if (!_dbContext.Abilities.Any())
            {
                var abilities = GetAbilities();
                _dbContext.Abilities.AddRange(abilities);
                _dbContext.SaveChanges();
            }
        }

        private IEnumerable<Ability> GetAbilities()
        {
            var abilities = new List<Ability>()
            {
                new Ability()
                {
                    Name = "Bardzo silny",
                    Description = "Bohater obdarzony jest wyjątkową siłą. Otrzymuje +5 do Krzepy, dodawane do początkowej wartości cechy"
                },
                new Ability()
                {
                    Name = "Błyskotliwość",
                    Description = "Bohater obdarzony jest wyjątkową inteligencją. Otrzymuje +5 do Inteligencji, dodawane do początkowej wartości cechy."
                }
            };

            return abilities;
        }
    }
}

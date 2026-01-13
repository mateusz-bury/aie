using AIO_API.Entities;
using AIO_API.Entities.Characters.Skills;
using AIO_API.Entities.Items;

namespace AIO_API.Data
{
    public class SkillSeeder
    {
        private readonly AieDbContext _dbContext;

        public SkillSeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Seed()
        {
            if (!_dbContext.Skills.Any())
            {
                var skills = GetItems();
                _dbContext.Skills.AddRange(skills);
                _dbContext.SaveChanges();
            }
        }

        private IEnumerable<Skill> GetItems()
        {
            var items = new List<Skill>()
            {
                new Skill()
                {
                    Name = "Charakteryzacja",
                    Description = "Wykorzystanie tej umiejętnosci pozwaa Bohaterowi maskować jego prawdziwy wygląd i udawać kogoś innego.",
                    Type = "Podstawowa",
                    SkillType = "Ogłada"
                },
                new Skill()
                {
                    Name = "Czytanie i pisanie",
                    Description = "Bohater potrafi czytać i pisać w dowolnym języku, którym umie się posługiwać.",
                    Type = "Zaawansowana",
                    SkillType = "Inteligencja"
                }
            };

            return items;
        }
    }
}

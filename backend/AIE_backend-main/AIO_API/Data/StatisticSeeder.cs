using AIO_API.Entities;
using AIO_API.Entities.Characters.Statistics;

namespace AIO_API.Data
{
    public class StatisticSeeder
    {
        private readonly AieDbContext _dbContext;
        private readonly Random _random = new Random();

        public StatisticSeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Seed()
        {
            // Nie seeduj ponownie, jeśli statystyki już istnieją
            if (_dbContext.Statistics.Any())
                return;

            var statistics = new List<Statistic>();

            var aldred = _dbContext.Characters
                            .First(u => u.Name == "Aldred");
            var meliret = _dbContext.Characters
                            .First(u => u.Name == "Meliret");

            // CharacterId: 6 i 7
            statistics.AddRange(CreateStatisticsForCharacter(aldred.id));
            statistics.AddRange(CreateStatisticsForCharacter(meliret.id));

            _dbContext.Statistics.AddRange(statistics);
            _dbContext.SaveChanges();
        }

        private IEnumerable<Statistic> CreateStatisticsForCharacter(int characterId)
        {
            var basic = CreateStatistic(characterId, StatisticType.Base, 25, 60);
            var current = CreateStatistic(characterId, StatisticType.Current, 30, 75, basic);

            return new[] { basic, current };
        }

        private Statistic CreateStatistic(
            int characterId,
            StatisticType type,
            int min,
            int max,
            Statistic? baseStats = null)
        {
            int Next(int from, int to) => _random.Next(from, to + 1);

            return new Statistic
            {
                CharacterId = characterId,
                StatisticType = type,

                BallisticSkill = baseStats != null ? baseStats.BallisticSkill + Next(1, 5) : Next(min, max),
                Strength = baseStats != null ? baseStats.Strength + Next(1, 5) : Next(min, max),
                Toughness = baseStats != null ? baseStats.Toughness + Next(1, 5) : Next(min, max),
                Agility = baseStats != null ? baseStats.Agility + Next(1, 5) : Next(min, max),
                Intelligence = baseStats != null ? baseStats.Intelligence + Next(1, 5) : Next(min, max),
                WillPower = baseStats != null ? baseStats.WillPower + Next(1, 5) : Next(min, max),
                Fellowship = baseStats != null ? baseStats.Fellowship + Next(1, 5) : Next(min, max),

                Attacks = baseStats != null ? baseStats.Attacks + 1 : Next(1, 2),
                Wounds = baseStats != null ? baseStats.Wounds + Next(1, 3) : Next(8, 14),
                Movement = 4,
                Magic = baseStats != null ? baseStats.Magic + 1 : Next(0, 2),
                InsanityPoints = 0,
                FatePoints = Next(1, 3)
            };
        }
    }
}

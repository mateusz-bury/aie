using AIO_API.Entities;
using AIO_API.Entities.Characters.Abilities;
using AIO_API.Interfaces.Repo;

namespace AIO_API.Repositories
{
    public class AbilityRepository : IAbilityRepository
    {
        private readonly AieDbContext _dbContext;
        public AbilityRepository(AieDbContext dbContext) 
        {
            _dbContext = dbContext;
        }
        public IEnumerable<Ability> GetAbilities()
        {
            var abilities = _dbContext.Abilities.ToList();
            return abilities;
        }
    }
}

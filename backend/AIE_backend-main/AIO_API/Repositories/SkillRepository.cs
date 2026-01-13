using AIO_API.Entities;
using AIO_API.Entities.Characters.Skills;
using AIO_API.Interfaces.Repo;

namespace AIO_API.Repositories
{
    public class SkillRepository : ISkillRepository
    {
        private readonly AieDbContext _dbContext;
        public SkillRepository(AieDbContext dbContext) 
        { 
            _dbContext = dbContext;
        }
        public IEnumerable<Skill> GetSkills()
        {
            var skills = _dbContext.Skills.ToList();
            return skills;
        }
    }
}

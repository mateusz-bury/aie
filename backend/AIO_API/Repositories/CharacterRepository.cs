using AIO_API.Entities;
using AIO_API.Entities.Characters;
using AIO_API.Interfaces;
using AIO_API.Models.CharacterDto;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Repositories
{
    public class CharacterRepository : ICharacterRepository
    {
        private readonly AieDbContext _dbContext;

        public CharacterRepository(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Add(Character character)
        {
            _dbContext.Characters.Add(character);
        }

        public void Remove(Character character)
        {
            _dbContext.Characters.Remove(character);
        }

        public void Update(Character character, UpdateCharacterDto dto)
        {
            _dbContext.Entry(character).CurrentValues.SetValues(dto);
        }

        public Character GetById(int id, int userId)
        {
            return _dbContext.Characters
                .Include(c => c.CharacterSkills)
                .ThenInclude(cs => cs.Skill)
                .Include(c => c.CharacterAbilities)
                .ThenInclude(ca => ca.Ability)
                .Include(c => c.CharacterItems)
                .ThenInclude(ci => ci.Item)
                .Include(c => c.Statistics)
                .Where(u => u.UserId == userId)
                .FirstOrDefault(c => c.id == id);
        }

        public IEnumerable<Character> GetAllForUser(int userId)
        {
            return _dbContext.Characters
                .Include(c => c.CharacterSkills)
                .ThenInclude(cs => cs.Skill)
                .Include(c => c.CharacterAbilities)
                .ThenInclude(ca => ca.Ability)
                .Include(c => c.CharacterItems)
                .ThenInclude(ci => ci.Item)
                .Include(c => c.Statistics)
                .Where(u => u.UserId == userId)
                .ToList();
        }

        public void SaveChanges()
        {
            _dbContext.SaveChanges();
        }
    }
}

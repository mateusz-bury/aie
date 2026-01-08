using AIO_API.Entities.Characters;
using AIO_API.Models.CharacterDto;

namespace AIO_API.Interfaces
{
    public interface ICharacterRepository
    {
        void Add(Character character);
        void Remove(Character character);
        Character GetById(int id, int userId);
        IEnumerable<Character> GetAllForUser(int userId);
        void SaveChanges();
        void Update(Character character, UpdateCharacterDto dto);
    }
}

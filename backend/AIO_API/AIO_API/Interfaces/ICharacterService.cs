using AIO_API.Models;

namespace AIO_API.Interfaces
{
    public interface ICharacterService
    {
        //Task<ICharacter> GetCharacterByIdAsync(int id);
        Task<IEnumerable<ICharacter>> GetAllCharactersAsync();
        //Task<ICharacter> CreateCharacterAsync(ICharacter character);
        //Task<bool> UpdateCharacterAsync(int id, ICharacter updatedCharacter);
        //Task<bool> DeleteCharacterAsync(int id);
    }
}

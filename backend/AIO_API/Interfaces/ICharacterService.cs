using AIO_API.Models;

namespace AIO_API.Interfaces
{
    public interface ICharacterService
    {
        PlayableCharacterDto GetById(int id);
        int Create(CreatePlayableCharacterDto dto);
        IEnumerable<PlayableCharacterDto> GetAll();
        bool Delete(int id);
        bool Update(int id, UpdatePlayableCharacterDto dto);
        //Task<ICharacter> CreateCharacterAsync(ICharacter character);
        //Task<bool> UpdateCharacterAsync(int id, ICharacter updatedCharacter);
        //Task<bool> DeleteCharacterAsync(int id);
    }
}

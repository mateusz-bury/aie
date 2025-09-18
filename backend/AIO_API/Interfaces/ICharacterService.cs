using AIO_API.Entities.Character;
using AIO_API.Models.CharacterDto;

namespace AIO_API.Interfaces
{
    public interface ICharacterService
    {

        public PlayableCharacterDto GetById(int id);
        public PlayableCharacter Create(int userId,CreatePlayableCharacterDto dto);
        public IEnumerable<PlayableCharacterDto> GetAll(int userId);
        public void Delete(int id);
        public void Update(int id,int userId, UpdatePlayableCharacterDto dto);

        //Task<ICharacter> CreateCharacterAsync(ICharacter character);
        //Task<bool> UpdateCharacterAsync(int id, ICharacter updatedCharacter);
        //Task<bool> DeleteCharacterAsync(int id);
    }
}

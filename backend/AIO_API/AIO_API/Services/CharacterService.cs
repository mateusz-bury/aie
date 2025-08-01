using AIO_API.Interfaces;
using AIO_API.Models;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Services
{
    public class CharacterService : ICharacterService
    {

        //public async Task<ICharacter> GetCharacterByIdAsync(int id);
        public async Task<IEnumerable<ICharacter>> GetAllCharactersAsync()
        {
            var characters = new List<ICharacter>
            {
                new PlayableCharacter
                {
                    Name = "Aldred",
                    Race = "Człowiek",
                    Career = "Wojownik"
                },
                new PlayableCharacter
                {
                    Name = "Meliret",
                    Race = "Elf",
                    Career = "Rzecznik Rodu"
                },
            };

            return await Task.FromResult(characters);
        }

        //public async Task<ICharacter> CreateCharacterAsync(ICharacter character);
        //public async Task<bool> UpdateCharacterAsync(int id, ICharacter updatedCharacter);
        //public async Task<bool> DeleteCharacterAsync(int id);
    }
}

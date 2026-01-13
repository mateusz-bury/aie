using AIO_API.Models.CharacterDto.Ability;

namespace AIO_API.Interfaces
{
    public interface IAbilityService
    {
        public IEnumerable<AbilityDto> GetAbilities();
    }
}

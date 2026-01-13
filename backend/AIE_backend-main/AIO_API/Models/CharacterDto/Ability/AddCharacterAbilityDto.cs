using AIO_API.Models.CharacterDto.Skill;

namespace AIO_API.Models.CharacterDto.Ability
{
    public class AddCharacterAbilityDto
    {
        public List<AddAbilityDto> Abilities { get; set; } = new List<AddAbilityDto>();
    }
}

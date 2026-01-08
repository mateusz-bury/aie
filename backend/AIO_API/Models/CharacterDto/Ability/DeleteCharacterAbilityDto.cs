namespace AIO_API.Models.CharacterDto.Ability
{
    public class DeleteCharacterAbilityDto
    {
        public List<DeleteAbilityDto> Abilities { get; set; } = new List<DeleteAbilityDto>();
    }
}

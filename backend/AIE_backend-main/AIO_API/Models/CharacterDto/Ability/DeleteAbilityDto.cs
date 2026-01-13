namespace AIO_API.Models.CharacterDto.Ability
{
    public class DeleteAbilityDto
    {
        public int AbilityId { get; set; }
        public int CharacterId { get; set; } = 0;
    }
}

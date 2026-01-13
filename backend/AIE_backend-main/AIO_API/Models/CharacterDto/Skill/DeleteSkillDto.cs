namespace AIO_API.Models.CharacterDto.Skill
{
    public class DeleteSkillDto
    {
        public int SkillId { get; set; }
        public int CharacterId { get; set; } = 0;
    }
}

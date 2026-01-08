namespace AIO_API.Entities.Characters.Skills
{
    public class Skill
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Type { get; set; }

        public string SkillType { get; set; }
        public ICollection<CharacterSkill> CharacterSkills { get; set; }
            = new List<CharacterSkill>();
    }
}

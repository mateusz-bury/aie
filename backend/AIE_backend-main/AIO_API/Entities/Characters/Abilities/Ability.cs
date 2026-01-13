namespace AIO_API.Entities.Characters.Abilities
{
    public class Ability
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public ICollection<CharacterAbility> CharacterAbilities { get; set; }
            = new List<CharacterAbility>();
    }
}

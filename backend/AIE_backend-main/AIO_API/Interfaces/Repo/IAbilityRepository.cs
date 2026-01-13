using AIO_API.Entities.Characters.Abilities;

namespace AIO_API.Interfaces.Repo
{
    public interface IAbilityRepository
    {
        IEnumerable<Ability> GetAbilities();
    }
}

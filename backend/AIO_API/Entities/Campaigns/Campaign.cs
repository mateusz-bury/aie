using AIO_API.Entities.Character;
using AIO_API.Entities.Users;

namespace AIO_API.Entities.Campaigns
{
    public class Campaign
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime CreateDate { get; set; }
        public int UserId { get; set; }
        public User User { get; set; }

        public ICollection<PlayableCharacter> PlayableCharacters { get; set; }
    }
}

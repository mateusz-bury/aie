using AIO_API.Entities.Characters;
using AIO_API.Entities.Users;
using AIO_API.Exceptions;

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

        public ICollection<Character> Characters { get; set; }
        public ICollection<CampaignSession> CampaignSessions { get; set; }



        public void Update(Campaign campaign)
        {
            if (campaign == null)
                throw new ArgumentNullException(nameof(campaign));

            Name = campaign.Name;
            Description = campaign.Description;
        }

        public void Create(int userId)
        {
            UserId = userId;
            CreateDate = DateTime.UtcNow;
            Characters = new List<Character>();
        }
    }
}

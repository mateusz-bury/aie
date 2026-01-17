using AIO_API.Entities.Campaigns;
using AIO_API.Interfaces;

namespace AIO_API.Entities
{
    public class CampaignSession : ICampaignSession
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public DateTime CreateDate { get; set; }
        public string? Description { get; set; }
        public int CampaignId { get; set; }
        public Campaign Campaign { get; set; }

        public void Create(int campaignId)
        {
            CampaignId = campaignId;
            CreateDate = DateTime.UtcNow;
        }
    }
}

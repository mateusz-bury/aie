using AIO_API.Entities.Campaigns;

namespace AIO_API.Models.CampaignDto
{
    public class CampaignDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime CreateDate { get; set; }
    }
}

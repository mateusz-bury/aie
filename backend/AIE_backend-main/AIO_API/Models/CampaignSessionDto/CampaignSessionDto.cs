namespace AIO_API.Models.CampaignSessionDto
{
    public class CampaignSessionDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime CreateDate { get; set; }
        public int CampaignId { get; set; }
    }
}

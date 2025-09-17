using AIO_API.Entities;
using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Character;

namespace AIO_API.Data
{
    public class CampaignSeeder
    {
        private readonly AieDbContext _dbContext;
        public CampaignSeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public void Seed()
        {
            if (_dbContext.Database.CanConnect())
            {
                if (!_dbContext.Campaigns.Any())
                {
                    var campaigns = GetCampaigns();
                    _dbContext.Campaigns.AddRange(campaigns);
                    _dbContext.SaveChanges();
                }
            }
        }

        private IEnumerable<Campaign> GetCampaigns()
        {
            var campaigns = new List<Campaign>()
            {
                new Campaign()
                {
                    Name = "1000 Tronów",
                    Description = "Kampania seedowana",
                    CreateDate = DateTime.Now,
                    UserId = 2
                }
            };

            return campaigns;
        }
    }
}

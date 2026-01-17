using AIO_API.Entities;
using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Characters;
using AIO_API.Exceptions;
using AIO_API.Interfaces.Repo;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Repositories
{
    public class CampaignRepository : ICampaignRepository
    {
        private readonly AieDbContext _dbContext;
        public CampaignRepository(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public Campaign GetCampaignById(int id, int userId)
        {
            var campaign = _dbContext
                            .Campaigns
                            .Include(ci => ci.Characters)
                            .Where(pc => pc.UserId == userId)
                            .FirstOrDefault(p => p.Id == id);
            if (campaign == null)
                throw new NotFoundException("Campaign not found");
            return campaign;
        }
        public IEnumerable<Campaign> GetAllCampaigns(int userId) {
            var campaigns = _dbContext.
                            Campaigns.
                            Where(pc => pc.UserId == userId).
                            ToList();
            if (campaigns == null)
                throw new NotFoundException("Campaigns not found");
            return campaigns;
        }

        public int AddCampaign(Campaign campaign)
        {
            _dbContext.Campaigns.Add(campaign);
            return campaign.Id;
        }
        
        public void DeleteCampaign(int id, int userId)
        {
            var campaign = _dbContext
                            .Campaigns
                            .Where(pc => pc.UserId == userId)
                            .FirstOrDefault(p => p.Id == id);
            if (campaign == null)
                throw new NotFoundException("Campaign not found");
            _dbContext.Campaigns.Remove(campaign);
        } 

        public IEnumerable<PlayableCharacter> GetPlayableCharactersInCampaign(int id, int userId)
        {
            var exists = _dbContext.Campaigns
                .Any(c => c.Id == id && c.UserId == userId);

            if (!exists)
                throw new NotFoundException("Campaign not found");

            return _dbContext.Characters
                .OfType<PlayableCharacter>()
                .Include(c => c.CharacterSkills)
                .ThenInclude(cs => cs.Skill)
                .Include(c => c.CharacterAbilities)
                .ThenInclude(ca => ca.Ability)
                .Include(c => c.CharacterItems)
                .ThenInclude(ci => ci.Item)
                .Include(c => c.Statistics)
                .Where(pc => pc.CampaignId == id)
                .ToList();
        }

        public IEnumerable<NpcCharacter> GetNpcCharactersInCampaign(int id, int userId)
        {
            var exists = _dbContext.Campaigns
                .Any(c => c.Id == id && c.UserId == userId);

            if (!exists)
                throw new NotFoundException("Campaign not found");

            return _dbContext.Characters
                .OfType<NpcCharacter>()
                .Include(c => c.CharacterSkills)
                .ThenInclude(cs => cs.Skill)
                .Include(c => c.CharacterAbilities)
                .ThenInclude(ca => ca.Ability)
                .Include(c => c.CharacterItems)
                .ThenInclude(ci => ci.Item)
                .Include(c => c.Statistics)
                .Where(pc => pc.CampaignId == id)
                .ToList();
        }

        public void SaveChanges()
        {
            _dbContext.SaveChanges();
        }
    }
}

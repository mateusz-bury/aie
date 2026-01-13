using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Characters;

namespace AIO_API.Interfaces.Repo
{
    public interface ICampaignRepository
    {
        public IEnumerable<Campaign> GetAllCampaigns(int userId);
        public Campaign GetCampaignById(int id, int userId);
        public int CreateCampaign(Campaign campaign);
        public void DeleteCampaign(int id, int userId);
        public IEnumerable<PlayableCharacter> GetPlayableCharactersInCampaign(int id, int userId);
        public IEnumerable<NpcCharacter> GetNpcCharactersInCampaign(int id, int userId);
        public void SaveChanges();

    }
}

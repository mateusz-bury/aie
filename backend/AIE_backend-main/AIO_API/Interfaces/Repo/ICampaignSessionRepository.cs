using AIO_API.Entities;

namespace AIO_API.Interfaces.Repo
{
    public interface ICampaignSessionRepository
    {
        public int CreateCampaignSession(CampaignSession campaignSession);
        public IEnumerable<CampaignSession> GetAllCampaignSessions(int campaignId);
        public CampaignSession GetCampaignSessionById(int campaignId, int sessionId);
        public CampaignSession UpdateCampaignSession(CampaignSession campaignSession);
        public void DeleteCampaignSession(int campaignId, int sessionId);
        public void SaveChanges();

    }
}

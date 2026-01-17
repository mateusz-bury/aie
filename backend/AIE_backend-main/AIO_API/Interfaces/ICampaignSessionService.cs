using AIO_API.Entities;
using AIO_API.Models.CampaignSessionDto;

namespace AIO_API.Interfaces
{
    public interface ICampaignSessionService
    {
        public CampaignSessionDto CreateCamapignSession(int campaignId, int userId, CreateCampaignSessionDto dto);
        public IEnumerable<CampaignSessionDto> GetAllCampaignSessions(int campaignId, int userId);
        public CampaignSessionDto UpdateCampaignSession(int campaignId, int sessionId, int userId, UpdateCampaignSessionDto dto);
        public void DeleteCampaignSession(int campaignId, int sessionId, int userId);
        public CampaignSessionDto GetCampaignSessionById(int campaignId, int sessionId, int userId);

    }
}

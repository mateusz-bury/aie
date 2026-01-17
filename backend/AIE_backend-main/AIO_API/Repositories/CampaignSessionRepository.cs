using AIO_API.Entities;
using AIO_API.Exceptions;
using AIO_API.Interfaces.Repo;

namespace AIO_API.Repositories
{
    public class CampaignSessionRepository : ICampaignSessionRepository
    {
        private readonly AieDbContext _dbContext;
        public CampaignSessionRepository(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }
        public int CreateCampaignSession(CampaignSession campaignSession)
        {
            _dbContext.CampaignSessions.Add(campaignSession);
            return campaignSession.Id;
        }
        public IEnumerable<CampaignSession> GetAllCampaignSessions(int campaignId)
        {
            return _dbContext
                   .CampaignSessions
                   .Where(cs => cs.CampaignId == campaignId)
                   .OrderByDescending(cs => cs.CreateDate)
                   .ToList();
        }
        public CampaignSession GetCampaignSessionById(int campaignId, int sessionId)
        {
            var session = _dbContext
                          .CampaignSessions
                          .FirstOrDefault(cs => cs.CampaignId == campaignId && cs.Id == sessionId);
            if (session == null)
                throw new NotFoundException("Campaign session not found");
            return session;
        }
        public void DeleteCampaignSession(int campaignId, int sessionId)
        {
            var session = _dbContext
                          .CampaignSessions
                          .FirstOrDefault(cs => cs.CampaignId == campaignId && cs.Id == sessionId);
            if (session == null)
                throw new NotFoundException("Campaign session not found");
            _dbContext.CampaignSessions.Remove(session);
        }

        public CampaignSession UpdateCampaignSession(CampaignSession campaignSession)
        {
            _dbContext.CampaignSessions.Update(campaignSession);
            return campaignSession;
        }
        public void SaveChanges()
        {
            _dbContext.SaveChanges();
        }
    }
}

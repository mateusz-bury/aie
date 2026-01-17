using AIO_API.Entities;
using AIO_API.Exceptions;
using AIO_API.Interfaces;
using AIO_API.Interfaces.Repo;
using AIO_API.Models.CampaignSessionDto;
using AutoMapper;

namespace AIO_API.Services
{
    public class CampaignSessionService : ICampaignSessionService
    {
        private readonly IMapper _mapper;
        private readonly ILogger<CampaignSessionService> _logger;
        private readonly ICampaignSessionRepository _repo;
        private readonly ICampaignRepository _campaignRepo;
        public CampaignSessionService(IMapper mapper, ILogger<CampaignSessionService> logger, ICampaignSessionRepository repo, ICampaignRepository campaignRepo)
        {
            _mapper = mapper;
            _logger = logger;
            _repo = repo;
            _campaignRepo = campaignRepo;
        }

        public CampaignSessionDto CreateCamapignSession(int campaignId, int userId, CreateCampaignSessionDto dto)
        {
            if (dto == null)
                throw new BadRequestException("Session data is required");

            var campaign = _campaignRepo.GetCampaignById(campaignId, userId);

            if (campaign == null)
                throw new NotFoundException($"Campaign with id {campaignId} not found for user {userId}");

            var session = _mapper.Map<CampaignSession>(dto);
            session.Create(campaignId);

            _repo.CreateCampaignSession(session);
            _repo.SaveChanges();
            
            //_logger.LogInformation("Created new campaign session {SessionId} for campaign {CampaignId} by user {UserId}", session.Id, campaignId, userId);
            
            var sessionDto = _mapper.Map<CampaignSessionDto>(session);

            return sessionDto;
        }

        public IEnumerable<CampaignSessionDto> GetAllCampaignSessions(int campaignId, int userId)
        {
            var campaign = _campaignRepo.GetCampaignById(campaignId, userId);
            if (campaign == null)
                throw new NotFoundException($"Campaign with id {campaignId} not found for user {userId}");

            var sessions = _repo.GetAllCampaignSessions(campaignId);
            var sessionDtos = _mapper.Map<List<CampaignSessionDto>>(sessions);

            return sessionDtos;
        }

        public CampaignSessionDto GetCampaignSessionById(int campaignId, int sessionId, int userId)
        {
            var campaign = _campaignRepo.GetCampaignById(campaignId, userId);
            if (campaign == null)
                throw new NotFoundException($"Campaign with id {campaignId} not found for user {userId}");
            var session = _repo.GetCampaignSessionById(campaignId, sessionId);

            var sessionDto = _mapper.Map<CampaignSessionDto>(session);
            return sessionDto;
        }

        public void DeleteCampaignSession(int campaignId, int sessionId, int userId)
        {
            var campaign = _campaignRepo.GetCampaignById(campaignId, userId);
            if (campaign == null)
                throw new NotFoundException($"Campaign with id {campaignId} not found for user {userId}");

            _repo.DeleteCampaignSession(campaignId,sessionId);
            _repo.SaveChanges();
            //_logger.LogInformation("Deleted campaign session {SessionId} from campaign {CampaignId} by user {UserId}", sessionId, campaignId, userId);
        }

        public CampaignSessionDto UpdateCampaignSession(int campaignId, int sessionId, int userId, UpdateCampaignSessionDto dto)
        {
            if (dto == null)
                throw new BadRequestException("Session data is required");

            if (string.IsNullOrWhiteSpace(dto.Title))
                throw new BadRequestException("Title is required");

            var campaign = _campaignRepo.GetCampaignById(campaignId, userId);
            if (campaign == null)
                throw new NotFoundException($"Campaign with id {campaignId} not found for user {userId}");

            var session = _repo.GetCampaignSessionById(campaignId, sessionId);
            session.Title = dto.Title.Trim();
            session.Description = dto.Description;

            _repo.UpdateCampaignSession(session);
            _repo.SaveChanges();

            return _mapper.Map<CampaignSessionDto>(session);
        }
    }
}

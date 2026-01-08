using AIO_API.Entities;
using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Characters;
using AIO_API.Exceptions;
using AIO_API.Interfaces;
using AIO_API.Models.CampaignDto;
using AIO_API.Models.CharacterDto;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Services
{
    
    public class CampaignService : ICampaignService
    {
        private readonly AieDbContext _dbContext;
        private readonly IMapper _mapper;
        private readonly ILogger<CharacterService> _logger;
        public CampaignService(AieDbContext dbContext, IMapper mapper, ILogger<CharacterService> logger)
        {
            _dbContext = dbContext;
            _mapper = mapper;
            _logger = logger;
        }

        public CampaignByIdDto GetById(int id, int userId)
        {
            var CampaignById = _dbContext
                            .Campaigns
                            .Include(ci => ci.PlayableCharacters)
                            .Where(pc => pc.UserId == userId)
                            .FirstOrDefault(p => p.Id == id);

            if (CampaignById == null)
                throw new NotFoundException("Campaign not found");

            var result = _mapper.Map<CampaignByIdDto>(CampaignById);

            return result;
        }

        public IEnumerable<CampaignDto> GetAll(int userId)
        {
            var allCampaigns = _dbContext.
                                   Campaigns.
                                   Where(pc => pc.UserId == userId).
                                   ToList();

            var allCampaignsDto = _mapper.Map<List<CampaignDto>>(allCampaigns);

            return allCampaignsDto;
        }

        public void UpdateCampaign(int campaignId, int userId, UpdateCampaignDto dto)
        {
            var updatedCampaign = _dbContext.
                                   Campaigns.
                                   Where(pc => pc.UserId == userId).
                                   FirstOrDefault(c => c.Id == campaignId);

            if (updatedCampaign == null)
                throw new NotFoundException("Campaign not found");

            updatedCampaign.Name = dto.Name;
            updatedCampaign.Description = dto.Description;

            _dbContext.SaveChanges();
        }
        public Campaign CreateCampaign(int userId, CreateCampaignDto dto)
        {
            var campaign = _mapper.Map<Campaign>(dto);
            campaign.CreateDate = DateTime.Now;
            campaign.UserId = userId;
            _dbContext.Campaigns.Add(campaign);
            _dbContext.SaveChanges();

            return campaign;
        }

        public void DeleteCampaign(int userId, int campaignId)
        {
            var deletedCampaign = _dbContext.
                                   Campaigns.
                                   Where(pc => pc.UserId == userId).
                                   FirstOrDefault(c => c.Id == campaignId);

            if (deletedCampaign == null)
                throw new NotFoundException("Campaign not found");

            _dbContext.Remove(deletedCampaign);
            _dbContext.SaveChanges();
        }

    }
}

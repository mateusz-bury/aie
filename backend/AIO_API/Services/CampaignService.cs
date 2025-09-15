using AIO_API.Entities;
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
                throw new NotFoundException("Character not found");

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

    }
}

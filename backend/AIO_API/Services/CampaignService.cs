using AIO_API.Entities;
using AIO_API.Exceptions;
using AIO_API.Interfaces;
using AIO_API.Models;
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

        public CampaignDto GetById(int id)
        {
            var CampaignById = _dbContext
                            .Campaigns
                            .FirstOrDefault(p => p.Id == id);

            if (CampaignById == null)
                throw new NotFoundException("Character not found");

            var result = _mapper.Map<CampaignDto>(CampaignById);

            return result;
        }

    }
}

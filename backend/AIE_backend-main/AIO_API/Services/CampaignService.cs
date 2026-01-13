using AIO_API.Entities;
using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Characters;
using AIO_API.Exceptions;
using AIO_API.Interfaces;
using AIO_API.Interfaces.Repo;
using AIO_API.Models.CampaignDto;
using AIO_API.Models.CharacterDto;
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Services
{
    
    public class CampaignService : ICampaignService
    {
        private readonly IMapper _mapper;
        private readonly ILogger<CharacterService> _logger;
        private readonly ICampaignRepository _repo;
        public CampaignService( IMapper mapper, ILogger<CharacterService> logger, ICampaignRepository repo)
        {
            _mapper = mapper;
            _logger = logger;
            _repo = repo;
        }

        public CampaignByIdDto GetById(int id, int userId)
        {
            var campaignById = _repo.GetCampaignById(id, userId);
            var campaignDto = _mapper.Map<CampaignByIdDto>(campaignById);
            return campaignDto;
        }

        public IEnumerable<CampaignDto> GetAll(int userId)
        {
            var allCampaigns = _repo.GetAllCampaigns(userId);
            var allCampaignsDto = _mapper.Map<List<CampaignDto>>(allCampaigns);
            return allCampaignsDto;
        }

        public void UpdateCampaign(int id, int userId, UpdateCampaignDto dto)
        {
            var updatedCampaign = _repo.GetCampaignById(id, userId);

            var mappedCampaign = _mapper.Map< Campaign>(dto);

            updatedCampaign.Update(mappedCampaign);

            _repo.SaveChanges();
        }
        public Campaign CreateCampaign(int userId, CreateCampaignDto dto)
        {
            if (dto == null)
                throw new BadRequestException("Campaign data is required");

            var campaign = Campaign.Create(
                dto.Name,
                dto.Description,
                userId
            );
            _repo.CreateCampaign(campaign);
            _repo.SaveChanges();

            return campaign;
        }

        public void DeleteCampaign(int id, int userId)
        {
            _repo.DeleteCampaign(id, userId);
            _repo.SaveChanges();
        }

        public IEnumerable<CharacterDto> GetPlayableCharactersInCampaign(int id, int userId)
        {
            var playableCharacters = _repo.GetPlayableCharactersInCampaign(id, userId);
            return _mapper.Map<List<CharacterDto>>(playableCharacters);
        }

        public IEnumerable<CharacterDto> GetNpcCharactersInCampaign(int id, int userId)
        {
            var npcCharacters = _repo.GetNpcCharactersInCampaign(id, userId);
            return _mapper.Map<List<CharacterDto>>(npcCharacters);
        }

    }
}

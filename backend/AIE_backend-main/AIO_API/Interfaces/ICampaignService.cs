using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Characters;
using AIO_API.Models.CampaignDto;
using AIO_API.Models.CharacterDto;

namespace AIO_API.Interfaces
{
    public interface ICampaignService
    {
        public CampaignByIdDto GetById(int id, int userId);
        public IEnumerable<CampaignDto> GetAll(int userId);
        public void UpdateCampaign(int id, int userId, UpdateCampaignDto dto);
        public Campaign CreateCampaign(int userId, CreateCampaignDto dto);
        public void DeleteCampaign(int id, int userId);
        public IEnumerable<CharacterDto> GetPlayableCharactersInCampaign(int id, int userId);
        public IEnumerable<CharacterDto> GetNpcCharactersInCampaign(int id, int userId);
    }
}

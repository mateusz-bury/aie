using AIO_API.Models.CampaignDto;

namespace AIO_API.Interfaces
{
    public interface ICampaignService
    {
        public CampaignByIdDto GetById(int id, int userId);
        public IEnumerable<CampaignDto> GetAll(int userId);
    }
}

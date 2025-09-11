using AIO_API.Models;

namespace AIO_API.Interfaces
{
    public interface ICampaignService
    {
        public CampaignDto GetById(int id);
        public IEnumerable<CampaignDto> GetAll(int userId);
    }
}

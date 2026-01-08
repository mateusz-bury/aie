using AIO_API.Models.CharacterDto;

namespace AIO_API.Models.CampaignDto
{
    public class CampaignByIdDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime CreateDate { get; set; }

        public List<AllCharacterDto> Characters { get; set; }
    }
}

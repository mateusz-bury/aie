using AIO_API.Entities.Campaigns;
using AIO_API.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{
    [Route("api/campaign")]
    [ApiController]
    public class CampaignController : ControllerBase
    {
        private ICampaignService _campaignService;

        public CampaignController(ICampaignService campaignService)
        {
            _campaignService = campaignService;
        }


        [HttpGet("{id}")]
        public ActionResult<Campaign> Get([FromRoute] int id)
        {
            var campaignById = _campaignService.GetById(id);
            return Ok(campaignById);
        }


    }
}

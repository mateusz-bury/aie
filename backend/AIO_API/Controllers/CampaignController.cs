using AIO_API.Entities.Campaigns;
using AIO_API.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

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
        [Authorize]
        public ActionResult<Campaign> Get([FromRoute] int id)
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value);

            var campaignById = _campaignService.GetById(id, userId);
            return Ok(campaignById);
        }

        [HttpGet]
        [Authorize]
        public ActionResult<IEnumerable<Campaign>> GetAll()
        {
            var userId = int.Parse(User.FindFirst(ClaimTypes.NameIdentifier).Value);

            var allCampaign = _campaignService.GetAll(userId);
            return Ok(allCampaign);
        }
    }
}

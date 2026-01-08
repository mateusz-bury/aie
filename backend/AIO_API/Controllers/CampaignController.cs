using AIO_API.Entities.Campaigns;
using AIO_API.Interfaces;
using AIO_API.Models.CampaignDto;
using AIO_API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace AIO_API.Controllers
{
    [Route("api/campaign")]
    [ApiController]
    [Authorize]
    public class CampaignController : ControllerBase
    {
        private ICampaignService _campaignService;
        private int UserId => int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        public CampaignController(ICampaignService campaignService)
        {
            _campaignService = campaignService;
        }


        [HttpGet("{id}")]
        public ActionResult<Campaign> Get([FromRoute] int id)
        {
            var campaignById = _campaignService.GetById(id, UserId);
            return Ok(campaignById);
        }

        [HttpGet]
        public ActionResult<IEnumerable<Campaign>> GetAll()
        {
            var allCampaign = _campaignService.GetAll(UserId);
            return Ok(allCampaign);
        }

        [HttpPut("{id}")]
        public ActionResult UpdateCampaign([FromRoute] int id, [FromBody] UpdateCampaignDto dto)
        {

            _campaignService.UpdateCampaign(id,UserId,dto);
            return Ok();
        }


        [HttpPost]
        public ActionResult<Campaign> CreateCampaign([FromBody] CreateCampaignDto dto)
        {

            var campaign = _campaignService.CreateCampaign(UserId,dto);
            return Ok(campaign);
        }

        [HttpDelete("{id}")]
        public ActionResult DeleteCampaign([FromRoute] int id)
        {

            _campaignService.DeleteCampaign(UserId, id);
            return NoContent();
        }

    }
}

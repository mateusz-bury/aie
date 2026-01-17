using AIO_API.Interfaces;
using AIO_API.Models.CampaignSessionDto;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace AIO_API.Controllers
{
    // Backward-compatible routes:
    // - /api/campaign/{campaignId}/session   (legacy)
    // - /api/campaign/{campaignId}/sessions  (preferred)
    [Route("api/campaign/{campaignId}/session")]
    [Route("api/campaign/{campaignId}/sessions")]
    [ApiController]
    [Authorize]
    public class CampaignSessionController : ControllerBase
    {
        private readonly ICampaignSessionService _sessionService;

        private int UserId => int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        public CampaignSessionController(ICampaignSessionService sessionService)
        {
            _sessionService = sessionService;
        }

        [HttpPost]
        public ActionResult<CampaignSessionDto> CreateSession(
            [FromRoute] int campaignId,
            [FromBody] CreateCampaignSessionDto dto)
        {
            var newSession = _sessionService.CreateCamapignSession(campaignId, UserId, dto);
            return Ok(newSession);
        }

        [HttpGet]
        public ActionResult<IEnumerable<CampaignSessionDto>> GetAllCampaignSessions([FromRoute] int campaignId)
        {
            var sessions = _sessionService.GetAllCampaignSessions(campaignId, UserId);
            return Ok(sessions);
        }

        [HttpGet("{sessionId:int}")]
        public ActionResult<CampaignSessionDto> GetCampaignSessionById(
            [FromRoute] int campaignId,
            [FromRoute] int sessionId)
        {
            var session = _sessionService.GetCampaignSessionById(campaignId, sessionId, UserId);
            return Ok(session);
        }

        [HttpPut("{sessionId:int}")]
        public ActionResult<CampaignSessionDto> UpdateCampaignSession(
            [FromRoute] int campaignId,
            [FromRoute] int sessionId,
            [FromBody] UpdateCampaignSessionDto dto)
        {
            var updated = _sessionService.UpdateCampaignSession(campaignId, sessionId, UserId, dto);
            return Ok(updated);
        }

        [HttpDelete("{sessionId:int}")]
        public ActionResult DeleteCampaignSession([FromRoute] int campaignId, [FromRoute] int sessionId)
        {
            _sessionService.DeleteCampaignSession(campaignId, sessionId, UserId);
            return NoContent();
        }
    }
}

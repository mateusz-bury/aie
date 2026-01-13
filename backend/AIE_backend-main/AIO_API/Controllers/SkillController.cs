using AIO_API.Interfaces;
using AIO_API.Models.CharacterDto;
using AIO_API.Models.CharacterDto.Skill;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace AIO_API.Controllers
{
    [Route("api/skills")]
    [ApiController]
    public class SkillController : ControllerBase
    {
        private ISkillService _skillService;

        public SkillController(ISkillService skillService)
        {
            _skillService = skillService;
        }

        [HttpGet]
        public ActionResult<IEnumerable<SkillDto>> GetSkills()
        {
            var skills = _skillService.GetSkills();
            return Ok(skills);
        }
    }
}

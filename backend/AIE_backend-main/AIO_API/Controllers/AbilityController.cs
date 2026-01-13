using AIO_API.Interfaces;
using AIO_API.Models.CharacterDto.Skill;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{
    [Route("api/abilities")]
    [ApiController]
    public class AbilityController : ControllerBase
    {
        private IAbilityService _abilityService;

        public AbilityController(IAbilityService abilityService)
        {
            _abilityService = abilityService;
        }

        [HttpGet]
        public ActionResult<IEnumerable<SkillDto>> GetAbilities()
        {
            var skills = _abilityService.GetAbilities();
            return Ok(skills);
        }
    }
}

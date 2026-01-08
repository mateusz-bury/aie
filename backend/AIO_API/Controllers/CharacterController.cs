using AIO_API.Data;
using AIO_API.Entities.Characters;
using AIO_API.Interfaces;
using AIO_API.Models.CharacterDto;
using AIO_API.Models.CharacterDto.Ability;
using AIO_API.Models.CharacterDto.Skill;
using AIO_API.Models.CharacterDto.Statistic;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace AIO_API.Controllers
{
    [Route("api/character")]
    [ApiController]
    [Authorize]
    public class CharacterController : ControllerBase
    {
        private ICharacterService _characterService;
        private int UserId => int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        public CharacterController(ICharacterService characterService)
        {
            _characterService = characterService;
        }

        [HttpPut("{id}")]
        public ActionResult Update([FromRoute]int id, [FromBody] UpdateCharacterDto dto)
        {
            _characterService.Update(id, UserId, dto);
            return Ok();
        }



        [HttpDelete("{id}")]
        public ActionResult Delete([FromRoute]int id)
        {
            _characterService.Delete(id, UserId);
            return NoContent();
        }

        [HttpPost]
        public ActionResult<Character> Create([FromBody] CreateCharacterDto dto)
        {
            var characterId = _characterService.Create(UserId, dto);
            return Created($"api/character/{characterId}", null);
        }

        [HttpGet]
        public ActionResult<IEnumerable<CharacterDto>> GetAll()
        {
            var CharactersDto = _characterService.GetAll(UserId);
            return Ok(CharactersDto);
        }



       [HttpGet("{id}")]
        public ActionResult<CharacterDto> Get([FromRoute] int id)
        {
            var CharacterByIdDto = _characterService.GetById(id, UserId);
            return Ok(CharacterByIdDto);
        }

        /// Skills Management

        [HttpPost("{id}/skills")]
        public ActionResult AddSkill(int id, [FromBody] AddCharacterSkillDto dto)
        {
            _characterService.AddSkill(id,UserId, dto);
            return Ok();
        }

        [HttpGet("skills")]
        public ActionResult<IEnumerable<SkillDto>> GetSkills()
        {
            var skills = _characterService.GetSkills();
            return Ok(skills);
        }

        [HttpDelete("{id}/skills")]
        public ActionResult DeleteSkill(int id, [FromBody] DeleteCharacterSkillDto dto)
        {
            _characterService.DeleteSkill(id,UserId, dto);
            return Ok();
        }

        /// Abilities Management
        
        [HttpPost("{id}/abilities")]
        public ActionResult AddAbility(int id, [FromBody] AddCharacterAbilityDto dto)
        {
            _characterService.AddAbility(id,UserId, dto);
            return Ok();
        }

        [HttpGet("abilities")]
        public ActionResult<IEnumerable<SkillDto>> GetAbilities()
        {
            var abilities = _characterService.GetAbilities();
            return Ok(abilities);
        }

        [HttpDelete("{id}/abilities")]
        public ActionResult DeleteAbility(int id, [FromBody] DeleteCharacterAbilityDto dto)
        {
            _characterService.DeleteAbility(id, UserId, dto);
            return Ok();
        }

        /// Statistics Management

        [HttpPost("{id}/statistics")]
        public ActionResult UpdateStatistic(int id, [FromBody] UpdateStatisticDto dto)
        {
            _characterService.UpdateStatistic(id, UserId, dto);
            return Ok();
        }


    }
}

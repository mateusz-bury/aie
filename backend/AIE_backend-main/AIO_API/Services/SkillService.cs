using AIO_API.Interfaces;
using AIO_API.Interfaces.Repo;
using AIO_API.Models.CharacterDto.Skill;
using AutoMapper;

namespace AIO_API.Services
{
    public class SkillService : ISkillService
    {
        private readonly ISkillRepository _repo;
        private readonly IMapper _mapper;
        private readonly ILogger<SkillService> _logger;

        public SkillService(IMapper mapper, ILogger<SkillService> logger, ISkillRepository repo) 
        {
            _repo = repo;
            _mapper = mapper;
            _logger = logger;
        }
        public IEnumerable<SkillDto> GetSkills()
        {
            var skills = _repo.GetSkills(); 
            return _mapper.Map<IEnumerable<SkillDto>>(skills);
        }
    }
}

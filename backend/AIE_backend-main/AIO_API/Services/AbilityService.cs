using AIO_API.Interfaces;
using AIO_API.Interfaces.Repo;
using AIO_API.Models.CharacterDto.Ability;
using AutoMapper;

namespace AIO_API.Services
{
    public class AbilityService : IAbilityService
    {
        private readonly IMapper _mapper;
        private readonly ILogger<AbilityService> _logger;
        private readonly IAbilityRepository _repo;
        public AbilityService(IMapper mapper, ILogger<AbilityService> logger, IAbilityRepository repo) 
        { 
            _mapper = mapper;
            _logger = logger;
            _repo = repo;
        }
        public IEnumerable<AbilityDto> GetAbilities()
        {
            var abilities = _repo.GetAbilities();
            return _mapper.Map<IEnumerable<AbilityDto>>(abilities);
        }
    }
}

using AIO_API.Entities.Character;
using AIO_API.Models;

using AutoMapper;

namespace AIO_API
{
    public class AieMappingProfile : Profile
    {
        public AieMappingProfile() 
        {
            CreateMap<Entities.Character.PlayableCharacter, PlayableCharacterDto>();
            CreateMap<CreatePlayableCharacterDto, Entities.Character.PlayableCharacter>();
            CreateMap<UpdatePlayableCharacterDto, Entities.Character.PlayableCharacter>();
            CreateMap<Entities.Character.PlayableCharacter, UpdatePlayableCharacterDto>();
        }
    }
}

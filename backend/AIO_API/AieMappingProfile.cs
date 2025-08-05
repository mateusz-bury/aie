using AIO_API.Entities;
using AIO_API.Models;
using AutoMapper;

namespace AIO_API
{
    public class AieMappingProfile : Profile
    {
        public AieMappingProfile() 
        {
            CreateMap<PlayableCharacter, PlayableCharacterDto>();
            CreateMap<CreatePlayableCharacterDto, PlayableCharacter>();
            CreateMap<UpdatePlayableCharacterDto, PlayableCharacter>();
            CreateMap<PlayableCharacter, UpdatePlayableCharacterDto>();
        }
    }
}

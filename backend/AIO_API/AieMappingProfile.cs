using AIO_API.Models;
using AIO_API.Models.UserDTO;
using AIO_API.Entities.Users;

using AutoMapper;

namespace AIO_API
{
    public class AieMappingProfile : Profile
    {
        public AieMappingProfile()
        {

            CreateMap<PlayableCharacter, PlayableCharacterDto>();
            CreateMap<PlayableCharacter, UpdatePlayableCharacterDto>();
            CreateMap<CreatePlayableCharacterDto, PlayableCharacter>();
            CreateMap<UpdatePlayableCharacterDto, PlayableCharacter>();


            // User maping
            CreateMap<User, UserDTO>()
                .ForMember(u => u.Id, c => c.MapFrom(u => u.Id))
                .ForMember(u => u.Username, c => c.MapFrom(u => u.Username))
                .ForMember(u => u.RoleId, c => c.MapFrom(u => u.Role));
        }
    }
}

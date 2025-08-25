using AIO_API.Models.UserDTO;
using AIO_API.Entities.Users;

using AutoMapper;
using AIO_API.Models.CharacterDto;
using AIO_API.Entities.Character;
using AIO_API.Models.EquipementDto;

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

            CreateMap<CreateCharacterItemDto, CharacterItem>();

            CreateMap<CharacterItem, CharacterItemDto>()
                .ForMember(dto => dto.CharacterId, m => m.MapFrom(ci => ci.CharacterId))
                .ForMember(dto => dto.ItemId, m => m.MapFrom(ci => ci.ItemId))
                .ForMember(dto => dto.Count, m => m.MapFrom(ci => ci.Count))
                .ForMember(dto => dto.Name, m => m.MapFrom(ci => ci.Item.Name))
                .ForMember(dto => dto.Description, m => m.MapFrom(ci => ci.Item.Description))
                .ForMember(dto => dto.Type, m => m.MapFrom(ci => ci.Item.Type))
                .ForMember(dto => dto.Price, m => m.MapFrom(ci => ci.Item.Price))
                .ForMember(dto => dto.Weight, m => m.MapFrom(ci => ci.Item.Weight));

        }
    }
}

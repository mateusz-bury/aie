using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Characters;
using AIO_API.Entities.Characters.Abilities;
using AIO_API.Entities.Characters.Skills;
using AIO_API.Entities.Characters.Statistics;
using AIO_API.Entities.Items;
using AIO_API.Entities.Users;
using AIO_API.Models.CampaignDto;
using AIO_API.Models.CharacterDto;
using AIO_API.Models.CharacterDto.Ability;
using AIO_API.Models.CharacterDto.Skill;
using AIO_API.Models.CharacterDto.Statistic;
using AIO_API.Models.EquipementDto;
using AIO_API.Models.ItemDto;
using AIO_API.Models.UserDTO;
using AutoMapper;

public class AieMappingProfile : Profile
{
    public AieMappingProfile()
    {
        // --- Character mapping ---

        // Baza Character -> CharacterDto (TPH)
        CreateMap<Character, CharacterDto>()
            .Include<PlayableCharacter, CharacterDto>()
            .Include<NpcCharacter, CharacterDto>()
            .ForMember(dest => dest.CharacterType,
                opt => opt.MapFrom(src =>
                    src is NpcCharacter ? CharacterType.Npc : CharacterType.Playable))
            .ForMember(dest => dest.Skills,
                opt => opt.MapFrom(src => src.CharacterSkills))
            .ForMember(dest => dest.Abilities,
                opt => opt.MapFrom(src => src.CharacterAbilities))
            .ForMember(dest => dest.Inventory,
                opt => opt.MapFrom(src => src.CharacterItems))
            .ForMember(dest => dest.Statistics,
                opt => opt.MapFrom(src => src.Statistics));

        // Specyficzne mapowania dziedziczące
        CreateMap<PlayableCharacter, CharacterDto>();
        CreateMap<NpcCharacter, CharacterDto>();

        // Tworzenie postaci
        CreateMap<CreateCharacterDto, PlayableCharacter>()
            .ForMember(dest => dest.id, opt => opt.Ignore())
            .ForMember(dest => dest.UserId, opt => opt.Ignore())
            .ForMember(dest => dest.Statistics, opt => opt.Ignore());

        CreateMap<CreateCharacterDto, NpcCharacter>()
            .ForMember(dest => dest.id, opt => opt.Ignore())
            .ForMember(dest => dest.UserId, opt => opt.Ignore())
            .ForMember(dest => dest.Statistics, opt => opt.Ignore());

        // --- Inventory / Items ---
        CreateMap<CharacterItem, InventoryDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Item.Id))
            .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Item.Name))
            .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Item.Description))
            .ForMember(dest => dest.Type, opt => opt.MapFrom(src => src.Item.Type))
            .ForMember(dest => dest.Weight, opt => opt.MapFrom(src => src.Item.Weight));

        CreateMap<CreateCharacterItemDto, CharacterItem>();
        CreateMap<CharacterItem, CharacterItemDto>()
            .ForMember(dest => dest.CharacterId, opt => opt.MapFrom(src => src.CharacterId))
            .ForMember(dest => dest.ItemId, opt => opt.MapFrom(src => src.ItemId))
            .ForMember(dest => dest.Count, opt => opt.MapFrom(src => src.Count))
            .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Item.Name))
            .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Item.Description))
            .ForMember(dest => dest.Type, opt => opt.MapFrom(src => src.Item.Type))
            .ForMember(dest => dest.Price, opt => opt.MapFrom(src => src.Item.Price))
            .ForMember(dest => dest.Weight, opt => opt.MapFrom(src => src.Item.Weight));

        // --- Skills ---
        CreateMap<AddSkillDto, CharacterSkill>();
        CreateMap<Skill, SkillDto>();
        CreateMap<CharacterSkill, SkillDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Skill.Id))
            .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Skill.Name))
            .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Skill.Description))
            .ForMember(dest => dest.Type, opt => opt.MapFrom(src => src.Skill.Type));

        // --- Abilities ---
        CreateMap<AddAbilityDto, CharacterAbility>();
        CreateMap<Ability, AbilityDto>();
        CreateMap<CharacterAbility, AbilityDto>()
            .ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Ability.Id))
            .ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Ability.Name))
            .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Ability.Description));

        // --- Items ---
        CreateMap<Item, ItemDto>();
        CreateMap<CreateItemDto, Item>();
        CreateMap<UpdateItemDto, Item>();

        // --- Statistics ---
        CreateMap<Statistic, StatisticDto>();
        CreateMap<CreateCharacterStatisticDto, Statistic>();
        CreateMap<UpdateStatisticDto, Statistic>();

        // --- Users ---
        CreateMap<User, UserDto>();

        // --- Campaigns ---
        CreateMap<Campaign, CampaignDto>();
        CreateMap<Campaign, CampaignByIdDto>();
        CreateMap<CreateCampaignDto, Campaign>();
    }
}

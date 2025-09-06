using AIO_API.Entities;
using AIO_API.Entities.Character;
using AIO_API.Exceptions;
using AIO_API.Models.EquipementDto;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using SQLitePCL;

namespace AIO_API.Services
{
    public interface ICharacterItemService 
    {
        int Create(int characterId, CreateCharacterItemDto dto);
        CharacterItemDto GetById(int characterId, int itemId);
        List<CharacterItemDto> GetAll(int characterId);
        void Delete(int characterId, int itemId);
    }
    public class CharacterItemService : ICharacterItemService
    {
        private readonly AieDbContext _dbContext;
        private readonly IMapper _mapper;

        public CharacterItemService(AieDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }
        public int Create(int characterId, CreateCharacterItemDto dto)
        {
            var character  = _dbContext.PlayableCharacter.FirstOrDefault(pc => pc.id == characterId);
            if (character == null)
                throw new NotFoundException("Character not found");

            var characterItemEntity = _mapper.Map<CharacterItem>(dto);

            characterItemEntity.CharacterId = characterId;

            _dbContext.CharacterItems.Add(characterItemEntity);
            _dbContext.SaveChanges();

            return characterItemEntity.ItemId;


        }

        public CharacterItemDto GetById(int characterId, int itemId)
        {
            var characterItem = _dbContext.CharacterItems
                                .Include(ci => ci.Item)
                                .FirstOrDefault(ci => ci.ItemId == itemId && ci.CharacterId == characterId);
            if (characterItem == null)
                throw new NotFoundException("Item not found");

            var characterItemDto = _mapper.Map<CharacterItemDto>(characterItem);

            return characterItemDto;
        }

        public List<CharacterItemDto> GetAll(int characterId)
        {
            var characterItems = _dbContext.CharacterItems
                                .Include(ci => ci.Item)
                                .Where(ci => ci.CharacterId == characterId)  
                                .ToList(); ;
            if (characterItems == null)
                throw new NotFoundException("Item not found");

            var characterItemDto = _mapper.Map<List<CharacterItemDto>>(characterItems);

            return characterItemDto;
        }

        public void Delete(int characterId, int itemId)
        {
            var characterItem = _dbContext.CharacterItems
                                .Include(ci => ci.Item)
                                .FirstOrDefault(ci => ci.ItemId == itemId && ci.CharacterId == characterId);
            if (characterItem == null)
                throw new NotFoundException("Item not found");

            _dbContext.Remove(characterItem);
            _dbContext.SaveChanges();
        }

    }
}

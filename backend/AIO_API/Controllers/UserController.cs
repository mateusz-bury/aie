using AIO_API.Entities;
using AIO_API.Entities.Users;
using AIO_API.Models.UserDTO;

using AutoMapper;

using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{

    [Route("api/user")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly AieDbContext _dbContext;
        private readonly IMapper _mapper;

        public UserController(AieDbContext dbContext, IMapper mapper)
        {
            _dbContext = dbContext;
            _mapper = mapper;
        }

        [HttpGet]
        public ActionResult<IEnumerable<User>> GetAll()
        {
            var user = _dbContext
                .Users
                .ToList();

            var userDTOs = _mapper.Map<List<UserDTO>>(user);

            return Ok(userDTOs);

        }

        [HttpGet("{id}")]
        public ActionResult<User> Get([FromRoute] int id)
        {
            var user = _dbContext
                .Users
                .FirstOrDefault(r => r.Id == id);

            if(user is null)
            {
                return NotFound();
            }
            else
            {
                var userDto = _mapper.Map<UserDTO>(user);
                return Ok(user);
            }
        }
    }

    
}

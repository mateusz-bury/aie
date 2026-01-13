using AIO_API.Data;
using AIO_API.Entities;
using AIO_API.Entities.Users;
using AIO_API.Models;
using Microsoft.AspNetCore.Mvc;

namespace AIO_API.Controllers
{
    [ApiController]
    [Route("api/auth")]
    public class AuthController : ControllerBase
    {
        private readonly AieDbContext _context;

        public AuthController(AieDbContext context)
        {
            _context = context;
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginRequest request)
        {
            var user = _context.Users.FirstOrDefault(u =>
                u.Username == request.Username &&
                u.PasswordHash == request.Password); 

            if (user == null)
            {
                return Unauthorized("Nieprawidłowy login lub hasło.");
            }

            return Ok(new
            {
                message = "Zalogowano pomyślnie!",
                user = new
                {
                    user.Id,
                    user.FirstName,
                    user.LastName,
                    user.Username,
                    user.Email,
                    user.RoleId
                }
            });
        }
    }
}

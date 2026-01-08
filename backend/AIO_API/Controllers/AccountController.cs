using AIO_API.Entities.Users;
using AIO_API.Models.UserDTO;
using AIO_API.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Identity.Client;
using System.Security.Claims;

namespace AIO_API.Controllers
{
    [ApiController]
    [Route("api/account")]
    public class AccountController : ControllerBase
    {
        private readonly IAccountService _accountService;
        private int UserId => int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        public AccountController(IAccountService accountService)
        {
            _accountService = accountService;
        }

        [HttpPost("register")]
        public ActionResult RegisterUser([FromBody] RegisterUserDto dto)
        {
            _accountService.RegisterUser(dto);
            return Ok();

        }

        [HttpPost("login")]
        public ActionResult Login([FromBody] LoginDto dto)
        {
            string token = _accountService.GenerateJwt(dto);

            return Ok(token);
        }

        [HttpPut("changePassword")]
        [Authorize]
        public ActionResult ChangePassword([FromBody] ChangePasswordDto dto)
        {
            _accountService.ChangePassword(UserId, dto);

            return Ok("Password has been changed successfully.");
        }

        [HttpGet("user")]
        [Authorize]
        public ActionResult Get()
        {
            var userInfo = _accountService.Get(UserId);

            return Ok(userInfo);
        }
    }
}

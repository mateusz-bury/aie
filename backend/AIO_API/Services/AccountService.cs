using AIO_API.Entities;
using AIO_API.Entities.Users;
using AIO_API.Exceptions;
using AIO_API.Models.CharacterDto;
using AIO_API.Models.UserDTO;
using AutoMapper;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace AIO_API.Services
{
    public interface IAccountService
    {
        void RegisterUser(RegisterUserDto dto);
        string GenerateJwt(LoginDto dto);
        void ChangePassword(int userId, ChangePasswordDto dto);
        public UserDto Get(int userId);
    }
    public class AccountService : IAccountService
    {
        private readonly AieDbContext _dbContext;
        private readonly IPasswordHasher<User> _passwordHasher;
        private readonly AuthenticationSettings _authenticationSettings;
        private readonly IMapper _mapper;
        public AccountService(AieDbContext dbContext, IPasswordHasher<User> passwordHasher, AuthenticationSettings authenticationSettings, IMapper mapper)
        {
            _dbContext = dbContext;
            _passwordHasher = passwordHasher;
            _authenticationSettings = authenticationSettings;
            _mapper = mapper;
        }
        public void RegisterUser(RegisterUserDto dto)
        {
            if (dto is null)
                throw new BadRequestException("Nieprawidłowe dane rejestracji.");

            var email = (dto.Email ?? string.Empty).Trim();
            var username = (dto.UserName ?? string.Empty).Trim();

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(dto.Password))
                throw new BadRequestException("Email, nazwa użytkownika i hasło są wymagane.");

            // Pre-check: unikamy DbUpdateException + 500
            var emailInUse = _dbContext.Users.Any(u => u.Email != null && u.Email.ToLower() == email.ToLower());
            if (emailInUse)
                throw new BadRequestException("Użytkownik o podanym adresie email już istnieje.");

            var usernameInUse = _dbContext.Users.Any(u => u.Username != null && u.Username.ToLower() == username.ToLower());
            if (usernameInUse)
                throw new BadRequestException("Użytkownik o podanej nazwie już istnieje.");

            // RoleId=4 bywa miną, jeśli tabela Roles jest pusta.
            // Bierzemy rolę "User" jeśli istnieje, a jeśli nie – tworzymy ją.
            var roleId = _dbContext.Roles
                .Where(r => r.Name != null && r.Name.ToLower() == "user")
                .Select(r => r.Id)
                .FirstOrDefault();

            if (roleId == 0)
            {
                var role = new Role { Name = "User" };
                _dbContext.Roles.Add(role);
                _dbContext.SaveChanges();
                roleId = role.Id;
            }

            var newUser = new User()
            {
                Email = email,
                FirstName = dto.FirstName,
                LastName = dto.LastName,
                Username = username,
                RoleId = roleId
            };

            newUser.PasswordHash = _passwordHasher.HashPassword(newUser, dto.Password);

            _dbContext.Users.Add(newUser);

            try
            {
                _dbContext.SaveChanges();
            }
            catch (DbUpdateException ex)
            {
                // Tu najczęściej wpada: unikalność albo FK (np. brak roli). Zwracamy 400 zamiast 500.
                throw new BadRequestException("Nie udało się zarejestrować użytkownika. Sprawdź czy email/nazwa są unikalne.");
            }

        }

        public string GenerateJwt(LoginDto dto)
        {
            var user = _dbContext.Users
                .Include(u => u.Role)
                .FirstOrDefault(u => u.Email == dto.Email);
            if (user is null)
            {
                throw new BadRequestException("Invalid email or password");
            }

            var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, dto.Password);
            if(result == PasswordVerificationResult.Failed)
            {
                throw new BadRequestException("Invalid email or password");
            }

            var claims = new List<Claim>()
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, $"{user.FirstName} {user.LastName}"),
                new Claim(ClaimTypes.Role, $"{user.Role.Name}")
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_authenticationSettings.JwtKey));

            var cred = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expires = DateTime.Now.AddDays(_authenticationSettings.JwtExpireDays);

            var token = new JwtSecurityToken(_authenticationSettings.JwtIssuer,
                _authenticationSettings.JwtIssuer,
                claims,
                expires: expires,
                signingCredentials: cred);

            var tokenHandler = new JwtSecurityTokenHandler();

            return tokenHandler.WriteToken(token);
        }

        public void ChangePassword(int userId, ChangePasswordDto dto)
        {
            var user = _dbContext.Users.FirstOrDefault(u => u.Id == userId);
            if (user is null)
            {
                throw new NotFoundException("User not found");
            }

            var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, dto.CurrentPassword);
            if (result == PasswordVerificationResult.Failed)
            {
                throw new BadRequestException("Current password is invalid");
            }

            user.PasswordHash = _passwordHasher.HashPassword(user, dto.NewPassword);

            _dbContext.SaveChanges();
        }

        public UserDto Get(int userId)
        {
            var userDto = _dbContext
                            .Users
                            .FirstOrDefault(u => u.Id == userId);

            if (userDto == null)
                throw new NotFoundException("Users not found");

            var result = _mapper.Map<UserDto>(userDto);

            return result;
        }

    }
}

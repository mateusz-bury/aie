using AIO_API.Entities;
using AIO_API.Entities.Users;
using Microsoft.AspNetCore.Identity;
using System.Collections.Generic;
using System.Linq;

namespace AIO_API.Data
{
    public class UsersSeeder
    {
        private readonly AieDbContext _dbContext;
        private readonly IPasswordHasher<User> _passwordHasher;

        public UsersSeeder(AieDbContext dbContext, IPasswordHasher<User> passwordHasher)
        {
            _dbContext = dbContext;
            _passwordHasher = passwordHasher;
        }

        public void Seed()
        {
            if (_dbContext.Database.CanConnect())
            {
                if (!_dbContext.Users.Any())
                {
                    var users = GetUsers();
                    _dbContext.Users.AddRange(users);
                    _dbContext.SaveChanges();
                }
            }
        }

        private IEnumerable<User> GetUsers()
        {
            var role = _dbContext.Roles
                            .First(r => r.Name == "Admin");
            var admin = new User
            {
                Email = "admin@aie.com",
                FirstName = "Admin",
                LastName = "Systemowy",
                Username = "admin",
                RoleId = role.Id
            };

            admin.PasswordHash = _passwordHasher.HashPassword(admin, "admin");

            return new List<User> { admin };
        }
    }
}

using System.Collections.Generic;
using System.Linq;

using AIO_API.Entities;
using AIO_API.Entities.Users;

namespace AIO_API.Data
{
    public class UsersSeeder
    {
        private readonly AieDbContext _dbContext;

        public UsersSeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Seed()
        {
            if (!_dbContext.Users.Any())
            {
                var users = GetUsers();
                _dbContext.Users.AddRange(users);
                _dbContext.SaveChanges();
            }
        }

        private IEnumerable<User> GetUsers()
        {
            return new List<User>()
            {
                new User
                {
                    Id = 1,
                    Email = "admin@aie.com",
                    FirstName = "Admin",
                    LastName = "Systemowy",
                    Username = "admin",
                    RoleId = 3,
                    PasswordHash = "admin", 
                }
            };
        }
    }
}

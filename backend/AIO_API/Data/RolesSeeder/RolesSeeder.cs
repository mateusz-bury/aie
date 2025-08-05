using System.Collections.Generic;
using System.Linq;

using AIO_API.Entities;
using AIO_API.Entities.Users;

namespace AIO_API.Data
{
    public class RolesSeeder
    {
        private readonly AieDbContext _dbContext;

        public RolesSeeder(AieDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Seed()
        {
            if (!_dbContext.Roles.Any())
            {
                var roles = GetRoles();
                _dbContext.Roles.AddRange(roles);
                _dbContext.SaveChanges();
            }
        }

        private IEnumerable<Role> GetRoles()
        {
            return new List<Role>()
            {
                new Role { Id = 1, Name = "Gracz" },
                new Role { Id = 2, Name = "Mistrz Gry" },
                new Role { Id = 3, Name = "Admin" }
            };
        }
    }
}

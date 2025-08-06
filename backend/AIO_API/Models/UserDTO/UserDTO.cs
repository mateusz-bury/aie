using AIO_API.Entities.Users;

namespace AIO_API.Models.UserDTO
{
    public class UserDTO
    {
        public int Id { get; set; }
        public string? Username { get; set; }
        public int RoleId { get; set; }

    }
}

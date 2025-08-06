using System.ComponentModel.DataAnnotations;

namespace AIO_API.Models.UserDTO
{
    public class CreateUserDTO
    {
        public string? Email { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Username { get; set; }
    }
}

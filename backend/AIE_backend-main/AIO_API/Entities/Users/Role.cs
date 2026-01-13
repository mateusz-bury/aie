using System.ComponentModel.DataAnnotations;

namespace AIO_API.Entities.Users
{
    public class Role
    {
        [Required]
        public int Id { get; set; }
        [Required]
        public string? Name { get; set; }
    }
}

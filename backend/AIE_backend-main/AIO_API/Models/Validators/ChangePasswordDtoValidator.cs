using AIO_API.Entities;
using AIO_API.Models.UserDTO;
using FluentValidation;

namespace AIO_API.Models.Validators
{
    public class ChangePasswordDtoValidator : AbstractValidator<ChangePasswordDto>
    {
        public ChangePasswordDtoValidator(AieDbContext dbContext) 
        {
            RuleFor(x => x.NewPassword)
                .MinimumLength(6);

            RuleFor(x => x.ConfirmPassword)
                .Equal(e => e.NewPassword)
                .WithMessage("Pole 'Confirm Password' musi być takie samo jak 'New Password'.");
        }
    }
}

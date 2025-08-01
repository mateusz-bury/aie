using AIO_API;
using AIO_API.Data;
using AIO_API.Interfaces;
using AIO_API.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

builder.Services.AddTransient<ICharacterService, CharacterService>();
builder.Services.AddDbContext<AieDbContext>();
builder.Services.AddTransient<PlayableCharacterSeeder>();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var seeder = scope.ServiceProvider.GetRequiredService<PlayableCharacterSeeder>();
    seeder.Seed();
}
// Configure the HTTP request pipeline.

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

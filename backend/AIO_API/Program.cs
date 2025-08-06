using System.Reflection;
using AIO_API.Data;
using AIO_API.Entities;
using AIO_API.Interfaces;
using AIO_API.Middleware;
using AIO_API.Services;

using AutoMapper;

using Microsoft.OpenApi.Models;

using NLog.Web;

var builder = WebApplication.CreateBuilder(args);

// ---------- LOGGING ----------
builder.Logging.ClearProviders();
builder.Logging.SetMinimumLevel(Microsoft.Extensions.Logging.LogLevel.Trace);
builder.Host.UseNLog();

// ---------- SERVICES ----------
builder.Services.AddControllers();
builder.Services.AddDbContext<AieDbContext>();
builder.Services.AddAutoMapper(Assembly.GetExecutingAssembly());

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterApp",
        policy =>
        {
            int port = 62861; // @Kuba - tu musz zmieniæ numer portu fluttera, próbowa³em go na szytywno ustawiæ w .json flattera ale jakoœ nie chce mi to dzialaæ - musisz popatrzeæ u siebie 
            policy.WithOrigins($"http://localhost:{port}") 
                  .AllowAnyHeader()
                  .AllowAnyMethod();
        });
});



// ---------- SEEDERS ----------
builder.Services.AddTransient<PlayableCharacterSeeder>();
builder.Services.AddTransient<ItemSeeder>();
builder.Services.AddTransient<CharacterItemSeeder>();
builder.Services.AddTransient<UsersSeeder>();
builder.Services.AddTransient<RolesSeeder>();

// ---------- MIDDLEWARE ----------
builder.Services.AddScoped<ErrorHandlingMiddleware>();
builder.Services.AddScoped<RequestTimeMiddleware>();

// ---------- CUSTOM SERVICES ----------
builder.Services.AddTransient<ICharacterService, CharacterService>();

// ---------- SWAGGER ----------
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "AIE API",
        Version = "v1"
    });
});

var app = builder.Build();

// ---------- SEED DATA ----------
using (var scope = app.Services.CreateScope())
{
    var playableCharacterSeeder = scope.ServiceProvider.GetRequiredService<PlayableCharacterSeeder>();
    playableCharacterSeeder.Seed();

    var itemSeeder = scope.ServiceProvider.GetRequiredService<ItemSeeder>();
    itemSeeder.Seed();

    var characterItemSeeder = scope.ServiceProvider.GetRequiredService<CharacterItemSeeder>();
    characterItemSeeder.Seed();

    var rolesSeeder = scope.ServiceProvider.GetRequiredService<RolesSeeder>();
    rolesSeeder.Seed();

    var usersSeeder = scope.ServiceProvider.GetRequiredService<UsersSeeder>();
    usersSeeder.Seed();
}

// ---------- MIDDLEWARE PIPELINE ----------
app.UseMiddleware<ErrorHandlingMiddleware>();
app.UseMiddleware<RequestTimeMiddleware>();

app.UseHttpsRedirection();

app.UseCors("AllowFlutterApp");

// ---------- SWAGGER UI ----------
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "AIE API v1");
    c.RoutePrefix = string.Empty; // <- otwiera swagger na http://localhost:<port>/
});

app.UseAuthorization();

app.MapControllers();

app.Run();

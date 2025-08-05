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
    options.AddPolicy("AllowLocalhost",
        policy =>
        {
            policy.WithOrigins("http://localhost:56588")
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

// ---------- SWAGGER UI ----------
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "AIE API v1");
    c.RoutePrefix = string.Empty; // <- otwiera swagger na http://localhost:<port>/
});
app.UseCors("AllowLocalhost");
app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

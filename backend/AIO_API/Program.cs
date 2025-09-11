using System.Reflection;
using System.Text;
using AIO_API;
using AIO_API.Data;
using AIO_API.Entities;
using AIO_API.Entities.Users;
using AIO_API.Interfaces;
using AIO_API.Middleware;
using AIO_API.Models.UserDTO;
using AIO_API.Models.Validators;
using AIO_API.Services;

using AutoMapper;
using FluentValidation;
using FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

using NLog.Web;

var builder = WebApplication.CreateBuilder(args);

// ---------- LOGGING ----------
builder.Logging.ClearProviders();
builder.Logging.SetMinimumLevel(Microsoft.Extensions.Logging.LogLevel.Trace);
builder.Host.UseNLog();

// ---------- SERVICES ----------
builder.Services.AddControllers().AddFluentValidation();
builder.Services.AddDbContext<AieDbContext>(option =>
{
    option.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});
builder.Services.AddAutoMapper(Assembly.GetExecutingAssembly());

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterApp",
        policy =>
        {
            int port = 50000;
            policy.WithOrigins($"http://localhost:{port}") 
                  .AllowAnyHeader()
                  .AllowAnyMethod();
        });
});

var autheniticationSettings = new AuthenticationSettings();
builder.Configuration.GetSection("Authentication").Bind(autheniticationSettings);
builder.Services.AddSingleton(autheniticationSettings);
builder.Services.AddAuthentication(option =>
{
    option.DefaultAuthenticateScheme = "Bearer";
    option.DefaultScheme = "Bearer";
    option.DefaultChallengeScheme = "Bearer";
}).AddJwtBearer(cfg =>
{
    cfg.RequireHttpsMetadata = false;
    cfg.SaveToken = true;
    cfg.TokenValidationParameters = new TokenValidationParameters
    {
        ValidIssuer = autheniticationSettings.JwtIssuer,
        ValidAudience = autheniticationSettings.JwtIssuer,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(autheniticationSettings.JwtKey)),
    };
});
// ---------- SEEDERS ----------
builder.Services.AddTransient<UsersSeeder>();
builder.Services.AddTransient<RolesSeeder>();
builder.Services.AddTransient<PlayableCharacterSeeder>();
builder.Services.AddTransient<ItemSeeder>();
builder.Services.AddTransient<CharacterItemSeeder>();
builder.Services.AddTransient<CampaignSeeder>();
// ---------- MIDDLEWARE ----------
builder.Services.AddScoped<ErrorHandlingMiddleware>();
builder.Services.AddScoped<RequestTimeMiddleware>();

// ---------- CUSTOM SERVICES ----------
builder.Services.AddTransient<ICharacterService, CharacterService>();
builder.Services.AddTransient<ICharacterItemService, CharacterItemService>();
builder.Services.AddTransient<ICampaignService, CampaignService>();
builder.Services.AddScoped<ICharacterItemService, CharacterItemService>();
builder.Services.AddScoped<IAccountService, AccountService>();
builder.Services.AddScoped<IPasswordHasher<User>, PasswordHasher<User>>();
builder.Services.AddScoped<IValidator<RegisterUserDto>, RegisterUserDtoValidator>();
builder.Services.AddScoped<IValidator<ChangePasswordDto>, ChangePasswordDtoValidator>();

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
    var rolesSeeder = scope.ServiceProvider.GetRequiredService<RolesSeeder>();
    rolesSeeder.Seed();

    var usersSeeder = scope.ServiceProvider.GetRequiredService<UsersSeeder>();
    usersSeeder.Seed();

    var campaignSeeder = scope.ServiceProvider.GetRequiredService<CampaignSeeder>();
    campaignSeeder.Seed();

    var playableCharacterSeeder = scope.ServiceProvider.GetRequiredService<PlayableCharacterSeeder>();
    playableCharacterSeeder.Seed();

    var itemSeeder = scope.ServiceProvider.GetRequiredService<ItemSeeder>();
    itemSeeder.Seed();

    var characterItemSeeder = scope.ServiceProvider.GetRequiredService<CharacterItemSeeder>();
    characterItemSeeder.Seed();
}

// ---------- MIDDLEWARE PIPELINE ----------
app.UseMiddleware<ErrorHandlingMiddleware>();
app.UseMiddleware<RequestTimeMiddleware>();

app.UseAuthentication();

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

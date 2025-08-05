using AIO_API;
using AIO_API.Data;
using AIO_API.Interfaces;
using AIO_API.Middleware;
using AIO_API.Services;
using AutoMapper;
using Microsoft.Data.SqlClient;
using NLog.Web;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);

//nlog

builder.Logging.ClearProviders();
builder.Logging.SetMinimumLevel(Microsoft.Extensions.Logging.LogLevel.Trace);
builder.Host.UseNLog();

// Add services to the container.

builder.Services.AddControllers();

builder.Services.AddTransient<ICharacterService, CharacterService>();
builder.Services.AddDbContext<AieDbContext>();
builder.Services.AddTransient<PlayableCharacterSeeder>();

builder.Services.AddTransient<ItemSeeder>();
builder.Services.AddTransient<CharacterItemSeeder>();
builder.Services.AddAutoMapper(Assembly.GetExecutingAssembly());
builder.Services.AddScoped<ErrorHandlingMiddleware>();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<RequestTimeMiddleware>();


var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var playableCharacterSeeder = scope.ServiceProvider.GetRequiredService<PlayableCharacterSeeder>();
    playableCharacterSeeder.Seed();
    var itemsSeeder = scope.ServiceProvider.GetRequiredService<ItemSeeder>();
    itemsSeeder.Seed();
    var characterItemsSeeder = scope.ServiceProvider.GetRequiredService<CharacterItemSeeder>();
    characterItemsSeeder.Seed();
}
// Configure the HTTP request pipeline.

app.UseMiddleware<ErrorHandlingMiddleware>();
app.UseMiddleware<RequestTimeMiddleware>();
app.UseHttpsRedirection();

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "AIE API");
});

app.UseAuthorization();

app.MapControllers();

app.Run();

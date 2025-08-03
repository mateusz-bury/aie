using AIO_API.Entities;
using Microsoft.EntityFrameworkCore;

namespace AIO_API.Data
{
    public class AieDbContext : DbContext
    {
        public DbSet<PlayableCharacter> PlayableCharacter { get; set; }

        private string _connectionString = "Server=localhost\\SQLEXPRESS;Database=AieDb;Trusted_Connection=True;";

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<PlayableCharacter>()
                .Property(p => p.Name)
                .IsRequired()
                .HasMaxLength(50);

            modelBuilder.Entity<PlayableCharacter>()
                .Property(p => p.Race)
                .IsRequired()
                .HasMaxLength(50);

            modelBuilder.Entity<PlayableCharacter>()
                .Property(p => p.Career)
                .IsRequired()
                .HasMaxLength(50);
            modelBuilder.Entity<PlayableCharacter>()
                .Property(p => p.Age)
                .IsRequired();
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(_connectionString);
        }
    }
}

using AIO_API.Entities.Character;
using AIO_API.Entities.Items;
using AIO_API.Entities.Users;

using Microsoft.EntityFrameworkCore;

namespace AIO_API.Entities
{
    public class AieDbContext : DbContext
    {
        // Users
        public DbSet<User> Users { get; set; }
        // Roles
        public DbSet<Role> Roles { get; set; }



        // Characters
        public DbSet<PlayableCharacter> PlayableCharacter { get; set; }
        public DbSet<CharacterItem> CharacterItems { get; set; }
        public DbSet<Item> Items { get; set; }


        public AieDbContext(DbContextOptions<AieDbContext> options): base(options)
        { 
        }

        private string _connectionString = "Server=(localdb)\\MSSQLLocalDB;Database=AieDb;Trusted_Connection=True;";

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            // Characters
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

            modelBuilder.Entity<CharacterItem>()
                .HasKey(ci => new { ci.CharacterId, ci.ItemId });

            modelBuilder.Entity<CharacterItem>()
                .HasOne(ci => ci.Character)
                .WithMany(p => p.CharacterItems)
                .HasForeignKey(ci => ci.CharacterId);

            modelBuilder.Entity<CharacterItem>()
                .HasOne(ci => ci.Item)
                .WithMany()
                .HasForeignKey(ci => ci.ItemId);
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(_connectionString);
        }
    }
}

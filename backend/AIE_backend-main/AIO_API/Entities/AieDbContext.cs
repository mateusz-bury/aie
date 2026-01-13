using AIO_API.Entities.Campaigns;
using AIO_API.Entities.Characters;
using AIO_API.Entities.Characters.Abilities;
using AIO_API.Entities.Characters.Skills;
using AIO_API.Entities.Characters.Statistics;
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
        public DbSet<Character> Characters { get; set; }
        public DbSet<PlayableCharacter> PlayableCharacter { get; set; }
        public DbSet<NpcCharacter> NpcCharacter { get; set; }

        public DbSet<Statistic> Statistics { get; set; }
        public DbSet<Skill> Skills { get; set; }
        public DbSet<CharacterSkill> CharacterSkills { get; set; }

        public DbSet<Ability> Abilities { get; set; }
        public DbSet<CharacterAbility> CharacterAbilities { get; set; }

        public DbSet<CharacterItem> CharacterItems { get; set; }
        public DbSet<Item> Items { get; set; }


        public DbSet<Campaign> Campaigns { get; set; }



        public AieDbContext(DbContextOptions<AieDbContext> options): base(options)
        { 
        }

        //private string _connectionString = "Server=(localdb)\\MSSQLLocalDB;Database=AieDb;Trusted_Connection=True;";

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Characters

            modelBuilder.Entity<Statistic>()
                .HasOne(s => s.Character)
                .WithMany(c => c.Statistics)
                .HasForeignKey(s => s.CharacterId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<Character>()
                .HasDiscriminator<string>("CharacterType")
                .HasValue<PlayableCharacter>("Playable")
                .HasValue<NpcCharacter>("Npc");

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

            modelBuilder.Entity<Campaign>()
                .Property(p => p.CreateDate)
                .HasColumnType("datetime");

            //Skills
            modelBuilder.Entity<CharacterSkill>()
                .HasIndex(cs => new { cs.CharacterId, cs.SkillId })
                .IsUnique();

            modelBuilder.Entity<CharacterSkill>()
                .HasOne(cs => cs.Character)
                .WithMany(c => c.CharacterSkills)
                .HasForeignKey(cs => cs.CharacterId);

            modelBuilder.Entity<CharacterSkill>()
                .HasOne(cs => cs.Skill)
                .WithMany(s => s.CharacterSkills)
                .HasForeignKey(cs => cs.SkillId);

            //Abilities
            modelBuilder.Entity<CharacterAbility>()
                .HasIndex(cs => new { cs.CharacterId, cs.AbilityId })
                .IsUnique();

            modelBuilder.Entity<CharacterAbility>()
                .HasOne(cs => cs.Character)
                .WithMany(c => c.CharacterAbilities)
                .HasForeignKey(cs => cs.CharacterId);

            modelBuilder.Entity<CharacterAbility>()
                .HasOne(cs => cs.Ability)
                .WithMany(s => s.CharacterAbilities)
                .HasForeignKey(cs => cs.AbilityId);



            modelBuilder.Entity<Campaign>()
            .HasOne(c => c.User)         
            .WithMany()                   
            .HasForeignKey(c => c.UserId) 
            .OnDelete(DeleteBehavior.NoAction);


        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
         //   optionsBuilder.UseSqlServer(_connectionString);
        }
    }
}

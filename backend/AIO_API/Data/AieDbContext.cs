
﻿using AIO_API.Entities;

using Microsoft.EntityFrameworkCore;

namespace AIO_API.Data
{
    public class AieDbContext : DbContext
    {
        public DbSet<PlayableCharacter> PlayableCharacter { get; set; }

        public DbSet<CharacterItem> CharacterItems { get; set; }
        public DbSet<Item> Items { get; set; }


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

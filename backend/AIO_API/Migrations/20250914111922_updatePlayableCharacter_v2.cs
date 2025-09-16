using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AIO_API.Migrations
{
    /// <inheritdoc />
    public partial class updatePlayableCharacter_v2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Agility",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Attacks",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "BallisticSkill",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "FatePoints",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Fellowship",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "InsanityPoints",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Intelligence",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Magic",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Movement",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Strength",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Toughness",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "WillPower",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Wounds",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Agility",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "Attacks",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "BallisticSkill",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "FatePoints",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "Fellowship",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "InsanityPoints",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "Intelligence",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "Magic",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "Movement",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "Strength",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "Toughness",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "WillPower",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "Wounds",
                table: "PlayableCharacter");
        }
    }
}

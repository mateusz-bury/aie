using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AIO_API.Migrations
{
    public partial class NewProprtyPlayableCharacter : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "WeaponSkill",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "WeaponSkill",
                table: "PlayableCharacter");
        }
    }
}

using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AIO_API.Migrations
{
    /// <inheritdoc />
    public partial class updateCharacterItems : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "CharacterItems",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Id",
                table: "CharacterItems");
        }
    }
}

using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AIO_API.Migrations
{
    /// <inheritdoc />
    public partial class changePlayableCharacters : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "UserId",
                table: "PlayableCharacter",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_PlayableCharacter_UserId",
                table: "PlayableCharacter",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_PlayableCharacter_Users_UserId",
                table: "PlayableCharacter",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PlayableCharacter_Users_UserId",
                table: "PlayableCharacter");

            migrationBuilder.DropIndex(
                name: "IX_PlayableCharacter_UserId",
                table: "PlayableCharacter");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "PlayableCharacter");
        }
    }
}

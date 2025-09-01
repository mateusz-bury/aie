using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AIO_API.Migrations
{
    /// <inheritdoc />
    public partial class addCampainTable2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "WeaponSkill",
                table: "PlayableCharacter",
                newName: "CampaignId");

            migrationBuilder.CreateTable(
                name: "Campaigns",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    CreateDate = table.Column<DateTime>(type: "datetime", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Campaigns", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_PlayableCharacter_CampaignId",
                table: "PlayableCharacter",
                column: "CampaignId");

            migrationBuilder.AddForeignKey(
                name: "FK_PlayableCharacter_Campaigns_CampaignId",
                table: "PlayableCharacter",
                column: "CampaignId",
                principalTable: "Campaigns",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PlayableCharacter_Campaigns_CampaignId",
                table: "PlayableCharacter");

            migrationBuilder.DropTable(
                name: "Campaigns");

            migrationBuilder.DropIndex(
                name: "IX_PlayableCharacter_CampaignId",
                table: "PlayableCharacter");

            migrationBuilder.RenameColumn(
                name: "CampaignId",
                table: "PlayableCharacter",
                newName: "WeaponSkill");
        }
    }
}

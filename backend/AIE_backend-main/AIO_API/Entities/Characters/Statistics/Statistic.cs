namespace AIO_API.Entities.Characters.Statistics
{
    public class Statistic
    {
        public int Id { get; set; }
        public int BallisticSkill { get; set; }
        public int Strength { get; set; }
        public int Toughness { get; set; }
        public int Agility { get; set; }
        public int Intelligence { get; set; }
        public int WillPower { get; set; }
        public int Fellowship { get; set; }

        public int Attacks { get; set; }
        public int Wounds { get; set; }
        public int Movement { get; set; }
        public int Magic { get; set; }
        public int InsanityPoints { get; set; }
        public int FatePoints { get; set; }
        public StatisticType StatisticType { get; set; }
        public int CharacterId { get; set; }
        public Character Character { get; set; }

        public void Update(Statistic statisticToUpdate)
        {
            BallisticSkill = statisticToUpdate.BallisticSkill;
            Strength = statisticToUpdate.Strength;
            Toughness = statisticToUpdate.Toughness;
            Agility = statisticToUpdate.Agility;
            Intelligence = statisticToUpdate.Intelligence;
            WillPower = statisticToUpdate.WillPower;
            Fellowship = statisticToUpdate.Fellowship;
            Attacks = statisticToUpdate.Attacks;
            Wounds = statisticToUpdate.Wounds;
            Movement = statisticToUpdate.Movement;
            Magic = statisticToUpdate.Magic;
            InsanityPoints = statisticToUpdate.InsanityPoints;
            FatePoints = statisticToUpdate.FatePoints;
        }
    }
}

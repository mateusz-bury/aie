using AIO_API.Interfaces;

namespace AIO_API.Entities.Character
{
    public class PlayableCharacter : ICharacter
    {
        public int id { get; set; }
        public string Name { get; set; }
        public string Race { get; set; }
        public string Career { get; set; }
        public short Age { get; set; }
        public int WeaponSkill { get; set; }

        public List<CharacterItem> CharacterItems { get; set; }
        //public int BallisticSkill { get; set; }
        //public int Strength { get; set; }
        //public int Toughness { get; set; }
        //public int Agility { get; set; }
        //public int Intelligence { get; set; }
        //public int WillPower { get; set; }
        //public int Fellowship { get; set; }

        //public int Attacks { get; set; }
        //public int Wounds { get; set; }
        //public int Movement { get; set; }
        //public int Magic { get; set; }
        //public int InsanityPoints { get; set; }
        //public int FatePoints { get; set; }


        //public List<string> Skills { get; set; } = new();
        //public List<string> Talents { get; set; } = new();
        //public List<string> Inventory { get; set; } = new();

        //public PlayableCharacter(string name, string race, string career)
        //{
        //    Name = name;
        //    Race = race;
        //    Career = career;
        //}

    }
}

#!/data/data/com.termux/files/usr/bin/bash

# This game was made by Blippy.

while true; do
    echo "Welcome to Blippy's bash script game."

    # Class stats description section
    sleep 2
    echo "Key Statistics:"
    sleep 1

    # Display stats descriptions
    echo "Hit Points (HP): Represents a character's"
    echo "health and vitality."

    echo "Magic Points (MP): Represents a character's"
    echo "ability to cast spells or use magical"
    echo "abilities."

    echo "Strength (STR): Determines a character's"
    echo "physical power and melee combat effectiveness."

    echo "Dexterity (DEX): Represents a character's"
    echo "agility, reflexes, and balance."

    echo "Constitution (CON): Determines a character's"
    echo "health, stamina, and resistance to disease."

    echo "Intelligence (INT): Represents a character's"
    echo "reasoning, memory, and analytical skills."

    echo "Wisdom (WIS): Determines a character's"
    echo "intuition, perception, and willpower."

    echo "Charisma (CHA): Represents a character's"
    echo "force of personality, confidence, & leadership."

    # Choosing a class section
    echo "Please choose a class."

    echo "Press 1 to choose the Noble class"
    echo "High charisma, social skills, and a leader."

    echo "Press 2 for the challenging Peasant class"
    echo "Poor, uneducated, and typically a farmer."

    echo "Press 3 showing discipline as the Monk class"
    echo "Unarmed combat, agility, and mental discipline."

    echo "Press 4 to battle as the Mercenary class"
    echo "Equipped with a range of weapons and armor."

    echo "Press 5 to adventure as the Traveler class"
    echo "Explore by navigation, piloting, and survival."

    echo "Press 6 to seek riches as the Merchant class"
    echo "Expertise in trade, bartering, and appraising."

    echo "Press 7 to gather knowledge as the Scholar"
    echo "Vast knowledge, healing abilities, and lore."

    read class

    case $class in
        1)
            type="Noble"
            HP=12
            MP=10
            STR=10
            DEX=1
	    CON=10
	    INT=11
	    WIS=10
	    CHA=15
            ;;
        2)
            type="Peasant"
            HP=13
            MP=10
            STR=13
            DEX=10
	    CON=12
	    INT=10
	    WIS=10
	    CHA=10
            ;;
        3)
            type="Monk"
            HP=12
            MP=10
            STR=10
            DEX=15
	    CON=10
	    INT=10
	    WIS=10
	    CHA=10
            ;;
        4)
            type="Mercenary"
            HP=13
            MP=10
            STR=13
            DEX=10
	    CON=11
	    INT=10
	    WIS=10
	    CHA=10
            ;;
        5)
            type="Traveler"
            HP=13
            MP=10
            STR=11
            DEX=11
	    CON=11
	    INT=10
	    WIS=10
	    CHA=10
            ;;
        6)
            type="Merchant"
            HP=10
            MP=10
            STR=10
            DEX=10
	    CON=10
	    INT=13
	    WIS=12
	    CHA=12
            ;;
        7)
            type="Scholar"
            HP=10
            MP=15
            STR=10
            DEX=10
	    CON=10
	    INT=15
	    WIS=10
	    CHA=10
            ;;
        *)
            echo "Invalid choice."
	    echo "Please choose a valid class."
            continue
            ;;
    esac

    # Display chosen class stats
    echo "You have chosen the $type class."
    echo "Your stats are:"
    echo "Hit Points: $HP"
    echo "Magic: $MP"
    echo "Strength: $STR"
    echo "Dexterity: $DEX"
    echo "Constitution: $CON"
    echo "Intelligence: $INT"
    echo "Wisdom: $WIS"
    echo "Charisma: $CHA"

    # Possible scenario section
done

# Scenario encounter section
encounter() {
    echo "You encounter a wild beast!"
    echo "What do you want to do?"
    echo "Press 1 to fight"
    echo "Press 2 to run"

    read action

    case $action in
        1)
            fight
            ;;
        2)
            echo "You run away safely."
            ;;
        *)
            echo "Invalid choice."
            echo "You hesitate and the beast attacks!"
            fight
            ;;
    esac
}

# Scenario battle section
fight() {
    # Ehp stands for enemy hit points
    # Eatk stands for enemy attack
    Ehp=15
    Eatk=12

    echo "You engage in a battle with the beast!"
    echo "Your HP: $hp"
    echo "Beast HP: $Ehp"

    while [ $hp -gt 0 ] && [ $Ehp -gt 0 ]; do
        # Player attacks
        damage=$(( RANDOM % atk + 1 ))
        Ehp=$(( Ehp - damage ))
        echo "You deal $damage damage to the beast."
        echo "Beast HP: $Ehp"

        if [ $Ehp -le 0 ]; then
            echo "You have defeated the beast!"
            break
        fi

#!/data/data/com.termux/files/usr/bin/bash

# This game is totally made up by Blippy Baggins with the
# help of Mistral AI.

while true; do
    echo "Welcome to Blippy Baggins' bash script game."

    # Class stats description section
    sleep 2
    echo "Key Statistics:"
    sleep 1

    # Display stats descriptions
    echo "Hit Points (HP): Represents a character's"
    echo "health and vitality."
    echo ""

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
    echo "force of personality, confidence, and leadership."

    # Choosing a class section
    echo "Please choose a class."
    echo "Press 1 for Noble"
    echo "Press 2 for Peasant"
    echo "Press 3 for Monk"
    echo "Press 4 for Mercenary"
    echo "Press 5 for Traveler"
    echo "Press 6 for Merchant"
    echo "Press 7 for Scholar"
    read class

    case $class in
        1)
            type="Noble"
            hp=12
            atk=11
            mag=10
            lck=13
            ;;
        2)
            type="Peasant"
            hp=10
            atk=10
            mag=10
            lck=10
            ;;
        3)
            type="Monk"
            hp=10
            atk=10
            mag=15
            lck=10
            ;;
        4)
            type="Mercenary"
            hp=12
            atk=13
            mag=10
            lck=10
            ;;
        5)
            type="Traveler"
            hp=11
            atk=11
            mag=10
            lck=13
            ;;
        6)
            type="Merchant"
            hp=10
            atk=10
            mag=10
            lck=15
            ;;
        7)
            type="Scholar"
            hp=10
            atk=10
            mag=15
            lck=10
            ;;
        *)
            echo "Invalid choice. Please choose a valid class."
            continue
            ;;
    esac

    # Display chosen class stats
    echo "You have chosen the $type class."
    echo "Your stats are:"
    echo "HP: $hp"
    echo "Attack: $atk"
    echo "Magic: $mag"
    echo "Luck: $lck"

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

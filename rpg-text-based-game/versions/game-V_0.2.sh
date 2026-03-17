#!/data/data/com.termux/files/usr/bin/bash

# This game was made by Blippy.

while true; do
    echo "Welcome to Blippy's bash script game."
    sleep 2
    echo "Hit Points (HP): Represents a character's"
    echo "health and vitality."
    sleep 3
    echo "Magic Points (MP): Represents a character's"
    echo "ability to cast spells or use magical"
    echo "abilities."
    sleep 4

    # Class Ability Score description section
    # Ask if the player wants to see the Ability Scores.
    echo "Want to read the character Ability Scores? (y/n)"
    read see_abilities

    if [[ $see_abilities == "y" ]]; then

    # Display Ability Score descriptions
    echo "Physical Ability Scores"
    sleep 1
    echo "Strength (STR): Determines a character's"
    echo "physical power and melee combat effectiveness."
    sleep 3
    echo "Dexterity (DEX): Represents a character's"
    echo "agility, reflexes, and balance."
    sleep 3
    echo "Constitution (CON): Determines a character's"
    echo "health, stamina, and resistance to disease."
    sleep 3
    echo "Mental and Social Ability Scores"
    sleep 3
    echo "Intelligence (INT): Represents a character's"
    echo "reasoning, memory, and analytical skills."
    sleep 3
    echo "Wisdom (WIS): Determines a character's"
    echo "intuition, perception, and willpower."
    sleep 3
    echo "Charisma (CHA): Represents a character's"
    echo "force of personality, confidence, & leadership."
    else
    echo "Skipping Ability Score descriptions."
    sleep 1
    fi

#    echo "Please choose a class."
#    sleep 2
#    echo "Press..."
#    sleep 1
#    echo "1 for Noble or 'a' for Noble description"
#    sleep 2
#    echo "2 for Peasent or 'b' for Peasent description"
#    sleep 1
#    echo "3 for Monk or 'c' for Monk description"
#    sleep 1
#    echo "4 for Mercenary or 'd' for Mercenary description"
#    sleep 1
#    echo "5 for Traveler or 'e' for Traveler description"
#    sleep 1
#    echo "6 for Merchant or 'f' for Merchant description"
#    sleep 1
#    echo "7 for Scholar or 'g' for Scholar description"
#    sleep 1

    # Class description section
#    echo "The Noble class:"
#    echo "High charisma, social skills, and a leader."
#    sleep 3
#    echo "The Peasant class:"
#    echo "Poor, uneducated, and typically a farmer."
#    sleep 3
#    echo "The Monk class:"
#    echo "Unarmed combat, agility, and mental discipline."
#    sleep 3
#    echo "The Mercenary class:"
#    echo "Equipped with a range of weapons and armor."
#    sleep 3
#    echo "The Traveler class:"
#    echo "Explore by navigation, piloting, and survival."
#    sleep 3
#    echo "The Merchant class:"
#    echo "Expertise in trade, bartering, and appraising."
#    sleep 3
#    echo "The Scholar class:"
#    echo "Vast knowledge, healing abilities, and lore."
#    read class
#
#    case $class in

    # Choosing a class section
    echo "Please choose a class by entering"
    echo "a number (1-7) or 'd' for the"
    echo "corresponding description."
choose_class() {
    echo "1) Noble"
    echo "2) Peasant"
    echo "3) Monk"
    echo "4) Mercenary"
    echo "5) Traveler"
    echo "6) Merchant"
    echo "7) Scholar"
    read class_choice

    case $class_choice in
        1)
            type="Noble"
            HP=11
            MP=11
	    # Ability Scores
	    echo "The Noble class:"
	    echo "Born of privilege, nobles command"
	    echo "respect and lead with authority."
            STR=10
            DEX=10
	    CON=10
	    INT=11
	    WIS=10
	    CHA=15
            ;;
        2)
            type="Peasant"
            HP=13
            MP=10
	    # Ability Scores
	    echo "The Peasant class:"
	    echo "Despite hardships, peasants endure"
	    echo "with resilience and resourcefulness."
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
	    # Ability Scores
            STR=10
            DEX=15
	    CON=10
	    INT=10
	    WIS=11
	    CHA=10
            ;;
        4)
            type="Mercenary"
            HP=14
            MP=10
	    # Ability Scores
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
            MP=11
	    # Ability Scores
            STR=11
            DEX=11
	    CON=11
	    INT=10
	    WIS=11
	    CHA=10
            ;;
        6)
            type="Merchant"
            HP=10
            MP=11
	    # Ability Scores
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
            MP=13
	    # Ability Scores
            STR=10
            DEX=10
	    CON=10
	    INT=15
	    WIS=10
	    CHA=10
            ;;
        *)
            echo "Invalid choice. Please try again."
	    # Re-prompt
            choose_class
            return
            ;;
    esac
    # Display chosen class details...
}

while true; do
    # Invoke function to choose class
    choose_class
done

#        *)
#            echo "Invalid choice."
#	    sleep 1
#	    echo "Please choose a valid class."
#            continue
#            ;;
#    esac

    echo "You have chosen the $type class."
    sleep 1
    # Display chosen class starting HP and MP
    echo "Your starting Hit Points: $HP"
    sleep 1
    echo "And Magic Points: $MP"
    sleep 1
    # Display chosen class Ability Scores
    echo "Your Ability Scores are:"
    sleep 1
    echo "Strength: $STR"
    echo "Dexterity: $DEX"
    echo "Constitution: $CON"
    echo "Intelligence: $INT"
    echo "Wisdom: $WIS"
    echo "Charisma: $CHA"
    sleep 5
done

# Scenario encounter section
encounter() {
    echo "You encounter a wild beast!"
    sleep 1
    echo "What do you want to do?"
    sleep 1
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
	    sleep 1
            echo "You hesitate and the beast attacks!"
            fight
            ;;
    esac
}

# Scenario battle section
fight() {
    # Enemy's health
    enemy_hp=10
    # Amount the enemy will hit for
    enemy_damage=3
    # Player's attack power varies slightly
    player_damage=$((STR + RANDOM % 3))

    echo "You engage in battle!"
    sleep 2
    while true; do
	# Player's turn
	echo "You attack the enemy for"
	echo "$player_damage damage!"
	enemy_hp=$((enemy_hp - player_damage))
	sleep 2
	echo "Enemy HP: $enemy_hp"
	sleep 2
        # Check if the enemy is defeated
        if [ "$enemy_hp" -le 0 ]; then
            echo "You defeated the enemy!"
            break
        fi

        # Enemy's turn
        echo "The enemy attacks you for"
	echo "$enemy_damage damage!"
        HP=$((HP - enemy_damage))
	sleep 1
        echo "Your HP: $HP"
   	sleep 2
        # Check if the player is defeated
        if [ "$HP" -le 0 ]; then
            echo "You have been defeated."
            exit
        fi

        echo "What do you want to do next?"
	sleep 1
        echo "Press 1 to continue fighting"
        echo "Press 2 to run away"
        read next_action

        case $next_action in
            1)
		# Go to the next iteration of the
		# while loop
                continue
                ;;
            2)
                echo "You run away safely."
		# Exit the fight loop
                break
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac
    done
}

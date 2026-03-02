#!/data/data/com.termux/files/usr/bin/bash

# Function to display key statistics
display_stats() {
    echo "Stat Description"
    echo "HP (Hit Points) Represents a character's"
    echo "health and vitality."
    echo "MP (Magic Points) Capacity to cast"
    echo "spells or use magical abilities."
    echo "STR (Strength) Determines a character's"
    echo "physical power and melee combat"
    echo "effectiveness."
    echo "DEX (Dexterity) Character's agility,"
    echo "reflexes, and balance."
    echo "CON (Constitution) Determines"
    echo "character's health, stamina, and"
    echo "resistance to disease."
    echo "INT (Intelligence) Represents a"
    echo "character's reasoning, memory, and"
    echo "analytical skills."
    echo "WIS (Wisdom) Determines a character's"
    echo "intuition, perception, and willpower."
    echo "CHA (Charisma) A character's force of"
    echo "personality, confidence, and leadership."
}

# Function to set player stats based on class
set_player_stats() {
    local class=$1
    case $class in
        1)
            PLAYER_CLASS="Noble"
            PLAYER_HP=12
            PLAYER_STR=11
            PLAYER_MP=10
            PLAYER_WIS=13
            PLAYER_DEX=10
            PLAYER_CON=10
            PLAYER_INT=10
            PLAYER_CHA=10
            ;;
        2)
            PLAYER_CLASS="Peasant"
            PLAYER_HP=10
            PLAYER_STR=10
            PLAYER_MP=10
            PLAYER_WIS=10
            PLAYER_DEX=10
            PLAYER_CON=10
            PLAYER_INT=10
            PLAYER_CHA=10
            ;;
        3)
            PLAYER_CLASS="Monk"
            PLAYER_HP=12
            PLAYER_STR=11
            PLAYER_MP=10
            PLAYER_WIS=13
            PLAYER_DEX=10
            PLAYER_CON=10
            PLAYER_INT=10
            PLAYER_CHA=10
            ;;
        4)
            PLAYER_CLASS="Mercenary"
            PLAYER_HP=12
            PLAYER_STR=11
            PLAYER_MP=10
            PLAYER_WIS=13
            PLAYER_DEX=10
            PLAYER_CON=10
            PLAYER_INT=10
            PLAYER_CHA=10
            ;;
        5)
            PLAYER_CLASS="Traveler"
            PLAYER_HP=12
            PLAYER_STR=11
            PLAYER_MP=10
            PLAYER_WIS=13
            PLAYER_DEX=10
            PLAYER_CON=10
            PLAYER_INT=10
            PLAYER_CHA=10
            ;;
        6)
            PLAYER_CLASS="Merchant"
            PLAYER_HP=12
            PLAYER_STR=11
            PLAYER_MP=10
            PLAYER_WIS=13
            PLAYER_DEX=10
            PLAYER_CON=10
            PLAYER_INT=10
            PLAYER_CHA=10
            ;;
        7)
            PLAYER_CLASS="Scholar"
            PLAYER_HP=12
            PLAYER_STR=11
            PLAYER_MP=10
            PLAYER_WIS=13
            PLAYER_DEX=10
            PLAYER_CON=10
            PLAYER_INT=10
            PLAYER_CHA=10
            ;;
        *)
            echo "Invalid choice."
            echo " Please choose a valid class."
            exit 1
            ;;
    esac
}

# Function to handle encounter
encounter() {
    echo "You encounter a wild beast!"

    sleep 1

    echo "What do you want to do?"

    sleep 2

    echo "Press 1 to fight"
    echo "Press 2 to run"

    read ACTION

    case $ACTION in
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

# Function to handle fight
fight() {
    ENEMY_TYPE="Beast"
    ENEMY_HP=12
    ENEMY_STR=13
    ENEMY_MP=10
    ENEMY_WIS=10
    ENEMY_DEX=10
    ENEMY_CON=12
    ENEMY_INT=10
    ENEMY_CHA=10

    echo "You engage the beast in battle! Prepare yourself"
    echo "Your HP: $PLAYER_HP"
    echo "$ENEMY_TYPE HP: $ENEMY_HP"

    while [ $PLAYER_HP -gt 0 ] && [ $ENEMY_HP -gt 0 ]; do
        # Player attacks
        DAMAGE=$(( RANDOM % PLAYER_STR + 1 ))
        ENEMY_HP=$(( ENEMY_HP - DAMAGE ))
        echo "You deal $DAMAGE damage to the $ENEMY_TYPE."
        echo "$ENEMY_TYPE HP: $ENEMY_HP"

        if [ $ENEMY_HP -le 0 ]; then
            echo "You have defeated the $ENEMY_TYPE!"
            break
        fi

        # Beast attacks
        DAMAGE=$(( RANDOM % ENEMY_STR + 1 ))
        PLAYER_HP=$(( PLAYER_HP - DAMAGE ))
        echo "The $ENEMY_TYPE deals $DAMAGE damage to you."
        echo "Your HP: $PLAYER_HP"

        if [ $PLAYER_HP -le 0 ]; then
            echo "You have been defeated by the"
	    echo "$ENEMY_TYPE."
            break
        fi

        # Check for critical hit based on DEX
        if [ $(( RANDOM % 100 )) -lt $PLAYER_DEX ]; then
            echo "Critical hit! You deal double damage!"
            DAMAGE=$(( 2 * (RANDOM % PLAYER_STR + 1) ))
            ENEMY_HP=$(( ENEMY_HP - DAMAGE ))
            echo "$DAMAGE damage dealt to $ENEMY_TYPE."
            echo "$ENEMY_TYPE HP: $ENEMY_HP"
        fi

        if [ $(( RANDOM % 100 )) -lt $ENEMY_DEX ]; then
            echo "Critical hit! The beast deals double damage!"
            DAMAGE=$(( 2 * (RANDOM % ENEMY_STR + 1) ))
            PLAYER_HP=$(( PLAYER_HP - DAMAGE ))
            echo "The $ENEMY_TYPE deals $DAMAGE damage to you."
            echo "Your HP: $PLAYER_HP"
        fi
    done
}

while true; do
    echo "Welcome to Blippy's bash script game."

    sleep 2

    # Class stats description section
    echo "Key Statistics:"
    echo "If you want to look at the eight key"
    echo "stats used for the outcome of character"
    echo "actions, please press the number"
    echo "zero ( 0"
)

    read STATS

    if [ $STATS -eq 0 ]; then
        display_stats
    else
        # Choosing a class section
        echo "Please press a number below to choose your character's class."
        echo "	Class				Description"
        echo "1  Noble			Natural leader."
        echo "2  Peasant		Rents or works land."
        echo "3  Monk			Devoted to life of religion."
        echo "4  Mercenary		Warrior or ex-military for hire."
        echo "5  Traveler		Explorer or wanderer."
        echo "6  Merchant		Deals in trading of goods and other things."
        echo "7  Scholar		A person of acadamia and study of books."

        read CLASS

        set_player_stats $CLASS

        encounter
    fi

    echo "Do you want to play again? (y/n)"
    read PLAY_AGAIN

    if [ $PLAY_AGAIN != "y" ]; then
        break
    fi
done

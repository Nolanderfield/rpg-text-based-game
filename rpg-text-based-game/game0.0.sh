#!/data/data/com.termux/files/usr/bin/bash

while true; do
    echo "Welcome to Blippy's bash script game."

    sleep 2

# Class stats description section
    echo "Key Statistics:"
    echo "If you want to look at the eight key stats used for the outcome of character actions,"
    echo "please press the number zero ( 0 )"

    read STATS

    if [ $STATS -eq 0; then
	echo "	Stat				Description"
	echo "HP (Hit Points)		Represents a character's health and vitality."
	echo "MP (Magic Points)		Capacity to cast spells or use magical abilities."
	echo "STR (Strength)		Determines a character's physical power and melee combat effectiveness."
	echo "DEX (Dexterity)		Character's agility, reflexes, and balance."
	echo "CON (Constitution)	Determines character's health, stamina, and resistance to disease."
	echo "INT (Intelligence)	Represents a character's reasoning, memory, and analytical skills."
	echo "WIS (Wisdom)		Determines a character's intuition, perception, and willpower."
	echo "CHA (Charisma)		A character's force of personality, confidence, and leadership."
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

	case $CLASS in
	    1)
		TYPE="Noble"
		HP=12
		STR=11
		MP=10
		WIS=13
		DEX=10
		CON=10
		INT=10
		CHA=10
		;;
	    2)
		TYPE="Peasant"
		HP=10
		STR=10
		MP=10
		WIS=10
		DEX=10
		CON=10
		INT=10
		CHA=10
		;;
	    3)
		TYPE="Monk"
		HP=12
		STR=11
		MP=10
		WIS=13
		DEX=10
		CON=10
		INT=10
		CHA=10
		;;
	    4)
		TYPE="Mercenary"
		HP=12
		STR=11
		MP=10
		WIS=13
		DEX=10
		CON=10
		INT=10
		CHA=10
		;;
	    5)
		TYPE="Traveler"
		HP=12
		STR=11
		MP=10
		WIS=13
		DEX=10
		CON=10
		INT=10
		CHA=10
		;;
	    6)
		TYPE="Merchant"
		HP=12
		STR=11
		MP=10
		WIS=13
		DEX=10
		CON=10
		INT=10
		CHA=10
		;;
	    7)
		TYPE="Scholar"
		HP=12
		STR=11
		MP=10
		WIS=13
		DEX=10
		CON=10
		INT=10
		CHA=10
		;;
	    *)
		echo "Invalid choice."
		echo " Please choose a valid class."
	esac
	continue
    fi

# Possible senario section

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

# Scenario battle section

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
    echo "Your HP: $HP"
    echo "$Beast HP: $ENEMY_HP"

    while [ $HP -gt 0 ] && [ $ENEMY_HP -gt 0 ]; do
        # Player attacks
        DAMAGE=$(( RANDOM % STR + 1 ))
        ENEMY_HP=$(( ENEMY_HP - DAMAGE ))
        echo "You deal $DAMAGE damage to the $Beast."
	echo "$Beast HP: $ENEMY_HP"

        if [ $ENEMY_HP -le 0 ]; then
            echo "You have defeated the $Beast!"
            break
        fi

        # Beast attacks
        DAMAGE=$(( RANDOM % ENEMY_STR + 1 ))
        HP=$(( HP - DAMAGE ))
        echo "The $Beast deals $DAMAGE damage to you."
	echo "Your HP: $HP"

        if [ $HP -le 0 ]; then
            echo "You have been defeated by the $Beast."
            break
        fi

        # Check for critical hit based on DEX
        if [ $(( RANDOM % 100 )) -lt $DEX ]; then
            echo "Critical hit! You deal double damage!"
            DAMAGE=$(( 2 * (RANDOM % STR + 1) ))
            ENEMY_HP=$(( ENEMY_HP - DAMAGE ))
            echo "You deal $DAMAGE damage to the $Beast."
	    echo "$Beast HP: $ENEMY_HP"
        fi

        if [ $ENEMY_HP -le 0 ]; then
            echo "You have defeated the $Beast!"
            break
        fi
    done
}

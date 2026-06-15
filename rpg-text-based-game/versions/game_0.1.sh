#!/data/data/com.termux/files/usr/bin/bash
# Text RPG - integrated improvements: robust save/load, inventory helpers, shop, skills/spells, improved combat AI
SAVEFILE="$HOME/.blippy_save"

set -o errexit
set -o nounset
set -o pipefail

# ---------- Helpers ----------
prompt_number() {
  local prompt="$1"; local min="$2"; local max="$3"; local ans
  while true; do
    read -rp "$prompt" ans || return 1
    [[ "$ans" =~ ^[0-9]+$ ]] || { echo "Please enter a number."; continue; }
    (( ans>=min && ans<=max )) || { echo "Enter a number between $min and $max."; continue; }
    echo "$ans"; return 0
  done
}
prompt_yesno() {
  local prompt="$1"; local ans
  while true; do
    read -rp "$prompt" ans || return 1
    case "${ans,,}" in y|yes) echo "y"; return 0;; n|no) echo "n"; return 0;; *) echo "Please answer y or n.";; esac
  done
}

# ---------- Inventory helpers ----------
INVENTORY=()
add_to_inventory() {
  INVENTORY+=("$1")
  echo "Added: $1"
}
remove_from_inventory_by_index() {
  local i=$1
  unset 'INVENTORY[i]'
  INVENTORY=("${INVENTORY[@]}")  # reindex
}
show_inventory() {
  if [ "${#INVENTORY[@]}" -eq 0 ]; then
    echo "Inventory: (empty)"; return
  fi
  echo "Inventory:"
  local i=1
  for it in "${INVENTORY[@]}"; do
    echo " $i) $it"
    i=$((i+1))
  done
}

# ---------- Save / Load ----------
SAVE_DIR="$(dirname "$SAVEFILE")"
mkdir -p "$SAVE_DIR"

save_game() {
  local inv_b64
  inv_b64=$(printf '%s\0' "${INVENTORY[@]}" | base64 | tr -d '\n')
  {
    printf '%s\n' "PLAYER_CLASS=${PLAYER_CLASS:-}"
    printf '%s\n' "PLAYER_LEVEL=${PLAYER_LEVEL:-1}"
    printf '%s\n' "PLAYER_XP=${PLAYER_XP:-0}"
    printf '%s\n' "PLAYER_MAX_HP=${PLAYER_MAX_HP:-10}"
    printf '%s\n' "PLAYER_HP=${PLAYER_HP:-10}"
    printf '%s\n' "PLAYER_MP=${PLAYER_MP:-0}"
    printf '%s\n' "PLAYER_STR=${PLAYER_STR:-5}"
    printf '%s\n' "PLAYER_DEX=${PLAYER_DEX:-5}"
    printf '%s\n' "PLAYER_CON=${PLAYER_CON:-5}"
    printf '%s\n' "PLAYER_INT=${PLAYER_INT:-5}"
    printf '%s\n' "PLAYER_WIS=${PLAYER_WIS:-5}"
    printf '%s\n' "PLAYER_CHA=${PLAYER_CHA:-5}"
    printf '%s\n' "INVENTORY_B64=$inv_b64"
  } > "$SAVEFILE"
  echo "Game saved."
}

load_game() {
  if [[ ! -f "$SAVEFILE" ]]; then
    echo "No save found."
    return 1
  fi
  local line key value
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "${line:0:1}" == "#" ]] && continue
    key=${line%%=*}
    value=${line#*=}
    case "$key" in
      PLAYER_CLASS) PLAYER_CLASS="$value" ;;
      PLAYER_LEVEL) PLAYER_LEVEL="$value" ;;
      PLAYER_XP) PLAYER_XP="$value" ;;
      PLAYER_MAX_HP) PLAYER_MAX_HP="$value" ;;
      PLAYER_HP) PLAYER_HP="$value" ;;
      PLAYER_MP) PLAYER_MP="$value" ;;
      PLAYER_STR) PLAYER_STR="$value" ;;
      PLAYER_DEX) PLAYER_DEX="$value" ;;
      PLAYER_CON) PLAYER_CON="$value" ;;
      PLAYER_INT) PLAYER_INT="$value" ;;
      PLAYER_WIS) PLAYER_WIS="$value" ;;
      PLAYER_CHA) PLAYER_CHA="$value" ;;
      INVENTORY_B64) INVENTORY_B64="$value" ;;
    esac
  done < "$SAVEFILE"

  INVENTORY=()
  if [[ -n "${INVENTORY_B64:-}" ]]; then
    local decoded
    if ! decoded=$(printf '%s' "$INVENTORY_B64" | base64 --decode 2>/dev/null); then
      decoded=$(printf '%s' "$INVENTORY_B64" | base64 -d 2>/dev/null) || { echo "Failed to decode inventory."; return 1; }
    fi
    IFS=$'\0' read -r -a INVENTORY <<< "$decoded"
  fi

  : "${PLAYER_MAX_HP:=$PLAYER_HP}"
  : "${PLAYER_LEVEL:=1}"
  : "${PLAYER_XP:=0}"
  echo "Game loaded."
  return 0
}

# Auto-save on signals
trap 'save_game; echo "Saved on exit."; exit' EXIT
trap 'echo; save_game; exit' SIGINT SIGTERM

# ---------- XP / Leveling ----------
XP_TO_LEVEL() { local lvl=$1; echo $(( 10 + lvl * 10 )); }
gain_xp() {
  local amount=$1
  PLAYER_XP=$(( PLAYER_XP + amount ))
  echo "Gained $amount XP. (XP: $PLAYER_XP/$(XP_TO_LEVEL $PLAYER_LEVEL))"
  while (( PLAYER_XP >= $(XP_TO_LEVEL $PLAYER_LEVEL) )); do
    PLAYER_XP=$(( PLAYER_XP - $(XP_TO_LEVEL $PLAYER_LEVEL) ))
    PLAYER_LEVEL=$(( PLAYER_LEVEL + 1 ))
    level_up
  done
}
level_up() {
  echo "Level up! Now level $PLAYER_LEVEL"
  PLAYER_MAX_HP=$(( PLAYER_MAX_HP + 4 ))
  PLAYER_HP=$PLAYER_MAX_HP
  PLAYER_STR=$(( PLAYER_STR + 1 ))
  PLAYER_DEX=$(( PLAYER_DEX + 1 ))
  PLAYER_CON=$(( PLAYER_CON + 1 ))
  PLAYER_MP=$(( PLAYER_MP + 1 ))
  echo "Max HP +4 (restored). STR+1 DEX+1 CON+1 MP+1"
}

# ---------- Player setup ----------
set_player_stats() {
  local class="$1"
  case "$class" in
    1) PLAYER_CLASS="Noble"; PLAYER_MAX_HP=14; PLAYER_STR=10; PLAYER_MP=12; PLAYER_WIS=12; PLAYER_DEX=11; PLAYER_CON=11; PLAYER_INT=11; PLAYER_CHA=13;;
    2) PLAYER_CLASS="Peasant"; PLAYER_MAX_HP=12; PLAYER_STR=11; PLAYER_MP=8; PLAYER_WIS=9; PLAYER_DEX=10; PLAYER_CON=12; PLAYER_INT=9; PLAYER_CHA=9;;
    3) PLAYER_CLASS="Monk"; PLAYER_MAX_HP=13; PLAYER_STR=12; PLAYER_MP=10; PLAYER_WIS=14; PLAYER_DEX=12; PLAYER_CON=11; PLAYER_INT=10; PLAYER_CHA=9;;
    4) PLAYER_CLASS="Mercenary"; PLAYER_MAX_HP=15; PLAYER_STR=13; PLAYER_MP=6; PLAYER_WIS=9; PLAYER_DEX=12; PLAYER_CON=13; PLAYER_INT=8; PLAYER_CHA=9;;
    5) PLAYER_CLASS="Traveler"; PLAYER_MAX_HP=13; PLAYER_STR=11; PLAYER_MP=9; PLAYER_WIS=11; PLAYER_DEX=12; PLAYER_CON=11; PLAYER_INT=11; PLAYER_CHA=11;;
    6) PLAYER_CLASS="Merchant"; PLAYER_MAX_HP=12; PLAYER_STR=9; PLAYER_MP=10; PLAYER_WIS=10; PLAYER_DEX=10; PLAYER_CON=10; PLAYER_INT=12; PLAYER_CHA=13;;
    7) PLAYER_CLASS="Scholar"; PLAYER_MAX_HP=11; PLAYER_STR=8; PLAYER_MP=14; PLAYER_WIS=13; PLAYER_DEX=9; PLAYER_CON=9; PLAYER_INT=14; PLAYER_CHA=9;;
    *) return 1;;
  esac
  PLAYER_LEVEL=1; PLAYER_XP=0; PLAYER_HP=$PLAYER_MAX_HP; INVENTORY=()
  # starter items
  add_to_inventory "Herb"
  add_to_inventory "Herb"
  add_to_inventory "Minor Mana Potion"
  return 0
}

# ---------- Enemies (improved AI) ----------
# Format: "Name:HP:STR:DEX:XP_reward:drop_item:behavior"
ENEMIES=(
  "Rat:6:6:5:5:Rat Tail:aggro"
  "Bandit:12:9:8:14:Bandit's Cloth:balanced"
  "Wolf:16:11:9:18:Wolf Pelt:aggro"
  "Beast:20:13:10:25:Beast Fang:berserk"
  "Goblin:12:8:12:10:Goblin Ear:balanced"
  "Bandit Captain:24:14:12:40:Captain's Crest:strategic"
)
random_enemy() {
  local idx=$(( RANDOM % ${#ENEMIES[@]} ))
  IFS=':' read -r E_NAME E_HP E_STR E_DEX E_XP E_DROP E_BEHAV <<< "${ENEMIES[idx]}"
  ENEMY_TYPE="$E_NAME"; ENEMY_HP="$E_HP"; ENEMY_STR="$E_STR"; ENEMY_DEX="$E_DEX"; ENEMY_XP="$E_XP"; ENEMY_DROP="$E_DROP"; ENEMY_BEHAV="$E_BEHAV"
}

# ---------- Items & Shop ----------
# Items are simple strings; usage handled in use_item_in_battle / inventory menu
SHOP_STOCK=(
  "Herb:5:Restores 3 HP"
  "Minor Health Potion:20:Restores 8 HP"
  "Minor Mana Potion:15:Restores 5 MP"
  "Antidote:12:Cures poison (not implemented)"
)

player_gold_init() { PLAYER_GOLD=${PLAYER_GOLD:-20}; }
player_gold_init

open_shop() {
  echo "Merchant's stall:"
  local i=1
  for item in "${SHOP_STOCK[@]}"; do
    IFS=':' read -r name price desc <<< "$item"
    echo " $i) $name - $price gold - $desc"
    i=$((i+1))
  done
  echo "0) Leave"
  local sel
  sel=$(prompt_number "Buy which (0 to leave): " 0 "${#SHOP_STOCK[@]}")
  if [ "$sel" -eq 0 ]; then echo "You leave the stall."; return; fi
  local idx=$((sel-1))
  IFS=':' read -r name price desc <<< "${SHOP_STOCK[idx]}"
  if (( PLAYER_GOLD >= price )); then
    PLAYER_GOLD=$(( PLAYER_GOLD - price ))
    add_to_inventory "$name"
    echo "You bought $name for $price gold. Gold: $PLAYER_GOLD"
  else
    echo "Not enough gold."
  fi
}

# ---------- Spells / Skills ----------
# Simple system: skills cost MP and do effects
show_skills() {
  echo "Skills:"
  echo " 1) Heal (cost 4 MP) - restore 10 HP"
  echo " 2) Firebolt (cost 3 MP) - deal 1d6 + INT damage"
  echo " 0) Back"
}
use_skill() {
  local choice
  show_skills
  choice=$(prompt_number "Choose skill: " 0 2)
  case "$choice" in
    0) return 0;;
    1)
      if (( PLAYER_MP < 4 )); then echo "Not enough MP."; return 1; fi
      PLAYER_MP=$(( PLAYER_MP - 4 ))
      PLAYER_HP=$(( PLAYER_HP + 10 ))
      if (( PLAYER_HP > PLAYER_MAX_HP )); then PLAYER_HP=$PLAYER_MAX_HP; fi
      echo "You cast Heal. HP: $PLAYER_HP/$PLAYER_MAX_HP MP:$PLAYER_MP"
      return 0
      ;;
    2)
      if (( PLAYER_MP < 3 )); then echo "Not enough MP."; return 1; fi
      PLAYER_MP=$(( PLAYER_MP - 3 ))
      local dmg=$(( (RANDOM % 6 + 1) + PLAYER_INT ))
      ENEMY_HP=$(( ENEMY_HP - dmg ))
      echo "You cast Firebolt for $dmg damage. ($ENEMY_HP left)"
      return 0
      ;;
  esac
}

# ---------- Combat helpers ----------
reward_enemy() {
  gain_xp "$ENEMY_XP"
  if (( RANDOM % 100 < 50 )); then add_to_inventory "$ENEMY_DROP"; fi
  # small gold reward
  local gold=$(( ENEMY_XP / 2 + RANDOM % (ENEMY_XP/2 + 1) ))
  PLAYER_GOLD=$(( PLAYER_GOLD + gold ))
  echo "You found $gold gold. (Gold: $PLAYER_GOLD)"
}

clamp() {
  local val=$1 min=$2 max=$3
  if (( val < min )); then echo $min; return; fi
  if (( val > max )); then echo $max; return; fi
  echo $val
}

# ---------- Combat (improved AI & actions) ----------
fight() {
  random_enemy
  echo "A wild $ENEMY_TYPE appears! (HP:$ENEMY_HP STR:$ENEMY_STR DEX:$ENEMY_DEX)"
  echo "Your HP: $PLAYER_HP/$PLAYER_MAX_HP MP:$PLAYER_MP Gold:$PLAYER_GOLD"
  while (( PLAYER_HP > 0 && ENEMY_HP > 0 )); do
    echo
    echo "Enemy: $ENEMY_TYPE HP:$ENEMY_HP | You: $PLAYER_HP/$PLAYER_MAX_HP MP:$PLAYER_MP"
    echo "Actions: 1) Attack 2) Skill 3) Use item 4) Flee"
    local act
    act=$(prompt_number "Choose (1-4): " 1 4)
    case "$act" in
      1)
        local damage=$(( RANDOM % PLAYER_STR + 1 ))
        ENEMY_HP=$(( ENEMY_HP - damage ))
        echo "You attack for $damage. ($ENEMY_HP left)"
        ;;
      2) use_skill || true ;;
      3) use_item_in_battle || echo "No usable item." ;;
      4)
        if (( RANDOM % 100 < 50 )); then echo "You fled successfully."; return 0; else echo "Failed to flee."; fi
        ;;
    esac

    if (( ENEMY_HP <= 0 )); then
      echo "You defeated $ENEMY_TYPE!"
      reward_enemy
      break
    fi

    # Enemy turn (AI behavior)
    enemy_take_action

    if (( PLAYER_HP <= 0 )); then
      echo "You were slain by $ENEMY_TYPE."
      break
    fi

    # Player passive crit chance after enemy based on DEX (capped)
    local dex_clamped
    dex_clamped=$(clamp "$PLAYER_DEX" 0 75)
    if (( RANDOM % 100 < dex_clamped )); then
      local crit=$(( 2 * (RANDOM % PLAYER_STR + 1) ))
      ENEMY_HP=$(( ENEMY_HP - crit ))
      echo "Critical! You deal $crit extra. ($ENEMY_HP left)"
      if (( ENEMY_HP <= 0 )); then
        echo "You defeated $ENEMY_TYPE!"
        reward_enemy
        break
      fi
    fi
  done
}

enemy_take_action() {
  # Behavior influences whether it prefers big hits or accuracy or heals (if implemented)
  case "$ENEMY_BEHAV" in
    aggro)
      local dmg=$(( RANDOM % ENEMY_STR + 1 ))
      PLAYER_HP=$(( PLAYER_HP - dmg ))
      echo "$ENEMY_TYPE aggressively attacks for $dmg. (You: $PLAYER_HP/$PLAYER_MAX_HP)"
      ;;
    berserk)
      # chance to do big hit
      if (( RANDOM % 100 < 40 )); then
        local dmg=$(( (RANDOM % ENEMY_STR + 1) * 2 ))
        PLAYER_HP=$(( PLAYER_HP - dmg ))
        echo "$ENEMY_TYPE goes berserk for $dmg! (You: $PLAYER_HP/$PLAYER_MAX_HP)"
      else
        local dmg=$(( RANDOM % ENEMY_STR + 1 ))
        PLAYER_HP=$(( PLAYER_HP - dmg ))
        echo "$ENEMY_TYPE hits for $dmg. (You: $PLAYER_HP/$PLAYER_MAX_HP)"
      fi
      ;;
    strategic)
      # reduce chance to attack if low HP (simulate defend)
      if (( ENEMY_HP < 5 && RANDOM % 100 < 60 )); then
        echo "$ENEMY_TYPE plays defensively."
        # minor regen
        ENEMY_HP=$(( ENEMY_HP + 2 ))
        echo "$ENEMY_TYPE regains 2 HP. ($ENEMY_HP)"
      else
        local dmg=$(( RANDOM % ENEMY_STR + 1 ))
        PLAYER_HP=$(( PLAYER_HP - dmg ))
        echo "$ENEMY_TYPE attacks for $dmg. (You: $PLAYER_HP/$PLAYER_MAX_HP)"
      fi
      ;;
    balanced|*)
      local dmg=$(( RANDOM % ENEMY_STR + 1 ))
      PLAYER_HP=$(( PLAYER_HP - dmg ))
      echo "$ENEMY_TYPE hits for $dmg. (You: $PLAYER_HP/$PLAYER_MAX_HP)"
      ;;
  esac
}

# ---------- Item usage in battle ----------
use_item_in_battle() {
  if [ "${#INVENTORY[@]}" -eq 0 ]; then return 1; fi
  show_inventory
  local idx
  idx=$(prompt_number "Use which item number (0 to cancel): " 0 "${#INVENTORY[@]}")
  if [ "$idx" -eq 0 ]; then echo "Canceled."; return 0; fi
  idx=$((idx-1)); local item="${INVENTORY[idx]}"
  case "$item" in
    "Beast Fang") echo "You use Beast Fang to heal 6 HP."; PLAYER_HP=$(( PLAYER_HP + 6 )); if (( PLAYER_HP > PLAYER_MAX_HP )); then PLAYER_HP=$PLAYER_MAX_HP; fi; remove_from_inventory_by_index "$idx";;
    "Herb") echo "You use Herb to restore 3 HP."; PLAYER_HP=$(( PLAYER_HP + 3 )); if (( PLAYER_HP > PLAYER_MAX_HP )); then PLAYER_HP=$PLAYER_MAX_HP; fi; remove_from_inventory_by_index "$idx";;
    "Minor Health Potion") echo "You drink Minor Health Potion (+8 HP)."; PLAYER_HP=$(( PLAYER_HP + 8 )); if (( PLAYER_HP > PLAYER_MAX_HP )); then PLAYER_HP=$PLAYER_MAX_HP; fi; remove_from_inventory_by_index "$idx";;
    "Minor Mana Potion") echo "You drink Minor Mana Potion (+5 MP)."; PLAYER_MP=$(( PLAYER_MP + 5 )); remove_from_inventory_by_index "$idx";;
    *) echo "That item has no effect right now.";;
  esac
  return 0
}

# ---------- Simple encounter helper ----------
encounter() {
  echo "You encounter a wild creature!"
  sleep 1
  echo "What do you want to do?"
  sleep 1
  echo "1) Fight"
  echo "2) Run"
  local ACTION
  ACTION=$(prompt_number "Choose 1-2: " 1 2)
  case "$ACTION" in
    1) fight ;;
    2) echo "You run away safely." ;;
  esac
}

# ---------- Data / Init ----------
player_gold_init

# ---------- Main Loop ----------
while true; do
  echo
  echo "1) New Game  2) Load Game  3) Quit"
  main_choice=$(prompt_number "Choose (1-3): " 1 3)
  case "$main_choice" in
    1)
      echo "Classes: 1) Noble 2) Peasant 3) Monk 4) Mercenary 5) Traveler 6) Merchant 7) Scholar"
      cls=$(prompt_number "Pick class (1-7): " 1 7)
      set_player_stats "$cls" || continue
      PLAYER_GOLD=${PLAYER_GOLD:-20}
      echo "Starting as $PLAYER_CLASS (Level $PLAYER_LEVEL XP $PLAYER_XP) Gold:$PLAYER_GOLD"
      ;;
    2)
      load_game || continue
      PLAYER_GOLD=${PLAYER_GOLD:-20}
      ;;
    3)
      echo "Goodbye."; exit 0
      ;;
  esac

  while true; do
    echo
    echo "Lvl:$PLAYER_LEVEL XP:$PLAYER_XP/$(XP_TO_LEVEL $PLAYER_LEVEL) HP:$PLAYER_HP/$PLAYER_MAX_HP MP:$PLAYER_MP STR:$PLAYER_STR DEX:$PLAYER_DEX CON:$PLAYER_CON INT:$PLAYER_INT WIS:$PLAYER_WIS CHA:$PLAYER_CHA Gold:$PLAYER_GOLD"
    echo "Actions: 1) Explore 2) Inventory 3) Shop 4) Save 5) Load 6) Quit to menu"
    act=$(prompt_number "Choose (1-6): " 1 6)
    case "$act" in
      1)
        event=$((RANDOM%6))
        case $event in
	  0) echo "You find a Herb."; add_to_inventory "Herb";;
	  1) encounter;;
	  2) echo "You meet a traveling merchant."; open_shop;;
	  3) echo "You wander and find nothing.";;
	  4) echo "You find a coin purse." g=$((RANDOM % 10 + 5)) PLAYER_GOLD=$((PLAYER_GOLD + g))
	     echo "Found $g gold. (Gold: $PLAYER_GOLD)"
	  5) echo "You discover an old chest."; if (( RANDOM % 100 < 40 )); then add_to_inventory "Minor Health Potion"; else echo "It's empty."; fi;;
        esac
        ;;
      2)
        show_inventory
        echo "1) Use item 2) Drop item 3) Back"
        sub=$(prompt_number "Choose (1-3): " 1 3)
        case "$sub" in
          1)
            if [ "${#INVENTORY[@]}" -eq 0 ]; then
              echo "No items."
            else
              show_inventory
              idx=$(prompt_number "Use which item number (0 cancel): " 0 "${#INVENTORY[@]}")
              if [ "$idx" -eq 0 ]; then
                echo "Canceled."
              else
                idx=$((idx-1)); itm=${INVENTORY[idx]}
                case "$itm" in
                  Herb) echo "Restore 3 HP."; PLAYER_HP=$((PLAYER_HP+3)); if (( PLAYER_HP > PLAYER_MAX_HP )); then PLAYER_HP=$PLAYER_MAX_HP; fi; remove_from_inventory_by_index "$idx";;
                  "Minor Health Potion") echo "Restore 8 HP."; PLAYER_HP=$((PLAYER_HP+8)); if (( PLAYER_HP > PLAYER_MAX_HP )); then PLAYER_HP=$PLAYER_MAX_HP; fi; remove_from_inventory_by_index "$idx";;
                  "Minor Mana Potion") echo "Restore 5 MP."; PLAYER_MP=$((PLAYER_MP+5)); remove_from_inventory_by_index "$idx";;
                  Beast*) echo "Use Beast Fang to heal 6 HP."; PLAYER_HP=$((PLAYER_HP+6)); if (( PLAYER_HP > PLAYER_MAX_HP )); then PLAYER_HP=$PLAYER_MAX_HP; fi; remove_from_inventory_by_index "$idx";;
                  *) echo "No effect.";;
                esac
              fi
            fi
            ;;
          2)
            if [ "${#INVENTORY[@]}" -eq 0 ]; then echo "No items to drop."; else show_inventory; idx=$(prompt_number "Drop which item number (0 cancel): " 0 "${#INVENTORY[@]}"); if [ "$idx" -eq 0 ]; then echo "Canceled."; else idx=$((idx-1)); echo "Dropped ${INVENTORY[idx]}"; remove_from_inventory_by_index "$idx"; fi; fi
            ;;
          3) ;;
        esac
        ;;
      3) open_shop;;
      4) save_game;;
      5) load_game;;
      6) break;;
    esac

    if (( PLAYER_HP <= 0 )); then
      echo "You have died. Returning to main menu."
      break
    fi
  done
done

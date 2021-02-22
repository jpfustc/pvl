## Game Flow Chart

```flow
st=>start: Initialize variables
deal=>operation: Deal the cards
claim=>operation: Claim the Land
play=>operation: Play a card
empty=>condition: Check if hand is empty
done=>end: Game over

start -> deal
deal -> claim
claim -> play
play -> empty
empty (yes) -> done
empty (no) -> play
```

## Data Structure
The game tracks the following data:

### Cards
Current cards of each player
* The cards are initialized when dealing
* Keep removing elements from the cards when playing
* Victory condition is met when a player has no card

Two options:
* represent cards as a set (considering suit, no repeated elements). Robust
* represent cards as a list:
* represent cards as a dict: with non repeated keys and number of each card as value

For the initial stage, we use list for simplification

### Last Hand
Only the last hand will be memorized by the game to check if the next play is legal
* Same as cards
* Plus id that played the hand

### Player id
The player id loops from 0 to 2 with each play
If the player id of the last hand matches the current player id, then the rest two player has passed, and the current player is entitled to play an arbitrary hand

### Multiplier
Certain conditions would trigger an increment of multiplier (multiple dips, bombs, etc)
This is an independent feature from the main function. Implement later

## IO
To begin with, consider a text io.
The current player will be prompt on the screen to select a hand of card to play, or to pass
The game will check the legitimacy of the play, and then move to the next player if the input is legal. Otherwise, the prompt loops.

## Check legitimacy of play

The function takes the last hand and the current hand as inputs, and return a bool value on whether the current hand is legal

There are two conditions to the legitimacy: whether the input is within the player's card, and whether it can out match the last hand

Raise prompts accordingly. Should this happen within legitimacy checking?

### Check if hands is available

### Check if 

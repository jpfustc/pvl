""""""

import random
from typing import Tuple

# o and O for junior and senior joker
CARDS = {
        '3': 4,
        '4': 4,
        '5': 4,
        '6': 4,
        '7': 4,
        '8': 4,
        '9': 4,
        'T': 4,
        'J': 4,
        'Q': 4,
        'K': 4,
        'A': 4,
        '2': 4,
        'o': 1,
        'O': 1
        }

def deal_card() -> Tuple[dict, dict, dict, dict]:
    """
    """
    card_string = _card_to_str(CARDS)
    card_list = list(card_string)
    random.shuffle(card_list)
    return (
            _str_to_card("".join(card_list[:17])),
            _str_to_card("".join(card_list[17:34])),
            _str_to_card("".join(card_list[34:51])),
            _str_to_card("".join(card_list[-3:])),
            )
def check_victory(hand_cards:dict) -> bool:
    """
    Return if a player wins by checking if he has empty hand cards after a play
    """
    return sum(hand_cards.values()) == 0

def _out_match(current_hand:dict) -> bool:
    """
    Check if a hand to be played can out match the last hand on table
    This is a complicated feature not to be exposed
    """
    # TODO
    return False

def check_validity(current_hand:list, hand_cards:list) -> bool:
    """
    Return if a hand to be played is valid by checking if all cards are available in player hand cards, and if it can out match last hand on the table
    """
    if not current_hand.keys() < hand_cards.keys():
        return False
    in_hand = all(current_hand[k] <= hand_cards[k] for k in current_hand)
    out_match = _out_match(current_hand)
    return in_hand and out_match

def play(current_hand:dict, hand_cards:dict) -> dict:
    """
    """
    for k in current_hand:
        hand_cards[k] -= current_hand[k]
    return hand_cards


def _str_to_card(input_cards:str) -> dict:
    """
    Parse a input string into card dictionary
    """
    input_cards = sorted(input_cards)
    current_hand = dict.fromkeys(input_cards, 0)
    for c in input_cards:
        current_hand[c] += 1
    return current_hand

def _card_to_str(cards:dict) -> str:
    """
    """
    card_str = ""
    for key in sorted(cards.keys()):
        card_str += key * cards[key]
    return card_str


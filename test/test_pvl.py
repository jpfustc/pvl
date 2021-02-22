from pvl.pvl import *
from pvl.pvl import _str_to_card, _card_to_str

def test_deal():
    p1, p2, p3, extra = deal_card()
    print(p1)
    print(p2)
    print(p3)
    print(extra)
    assert len(_card_to_str(p1)) == 17
    assert len(_card_to_str(p2)) == 17
    assert len(_card_to_str(p3)) == 17
    assert len(_card_to_str(extra)) == 3



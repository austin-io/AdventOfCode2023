import std/algorithm
import std/strutils
import std/tables

const CARD_MAP = toTable[char, int]([
    ('2', 1),
    ('3', 2),
    ('4', 3),
    ('5', 4),
    ('6', 5),
    ('7', 6),
    ('8', 7),
    ('9', 8),
    ('T', 9),
    ('J', 10),
    ('Q', 11),
    ('K', 12),
    ('A', 13),
])

const CARD_MAP_WILDCARD = toTable[char, int]([
    ('2', 1),
    ('3', 2),
    ('4', 3),
    ('5', 4),
    ('6', 5),
    ('7', 6),
    ('8', 7),
    ('9', 8),
    ('T', 9),
    ('J', 0), # Joker is weakest
    ('Q', 11),
    ('K', 12),
    ('A', 13),
])

type 
    HandType = enum
        HighCard = 1, OnePair, TwoPair, ThreeKind, FullHouse, FourKind, FiveKind

type 
    HandData = object
        hand: string
        hType: HandType = HighCard
        bid: int
        rank: int

proc GetHandType(handData: HandData) : HandType =

    var cardMap : Table[char, int]
    var highest = 0
    var twoCount = 0

    for card in handData.hand:
        if(cardMap.hasKey(card)):
            cardMap[card] += 1
            continue

        cardMap[card] = 1
    
    for k,cardCount in cardMap:
        highest = max(cardCount, highest)
        if(cardCount == 2):
            twoCount += 1
    
    case highest:
        of 5:
            return FiveKind
        of 4:
            return FourKind
        of 3:
            if(twoCount == 1):
                return FullHouse
            return ThreeKind
        of 2:
            if(twoCount == 2):
                return TwoPair
            return OnePair
        else:
            return HighCard

proc GetHandTypeWithWildCard(handData: HandData) : HandType =

    var cardMap : Table[char, int]
    var highest = 0
    var highestChar : char 
    var twoCount = 0
    var jokerCount = 0

    for card in handData.hand:
        if(card == 'J'): jokerCount+=1
        if(cardMap.hasKey(card)):
            cardMap[card] += 1
            continue

        cardMap[card] = 1
    
    for k,cardCount in cardMap:
        if(k == 'J'): continue
        if(cardCount > highest):
            highest = cardCount
            highestChar = k
    
    if(highest > 0):
        cardMap[highestChar] += jokerCount

    highest += jokerCount

    for k,cardCount in cardMap:
        if(cardCount == 2 and k != 'J'):
            twoCount += 1

    case highest:
        of 5:
            return FiveKind
        of 4:
            return FourKind
        of 3:
            if(twoCount == 1):
                return FullHouse
            return ThreeKind
        of 2:
            if(twoCount == 2):
                return TwoPair
            return OnePair
        else:
            return HighCard

# return value:
# -1 -> h1 is greater
#  0 -> equal
#  1 -> h2 is greater
proc CompareHands(h1, h2 : HandData, cardMap: Table[char, int]) : int =

    if(h1.hType > h2.hType):
        return -1
    elif(h1.hType < h2.hType):
        return 1

    for i in 0..h1.hand.high:
        var h1Strength = cardMap[h1.hand[i]]
        var h2Strength = cardMap[h2.hand[i]]

        if(h1Strength == h2Strength): continue

        if(h1Strength > h2Strength): return -1
        return 1

    return 0

proc Part1() =
    var lines = readFile("input.txt").splitLines

    var hands : seq[HandData] = @[]
    var totalWinnings = 0

    for line in lines:
        var lineSplit = line.splitWhitespace
        var newHand = HandData(hand: lineSplit[0], bid: lineSplit[1].parseInt)
        newHand.hType = GetHandType(newHand)
        hands.add(newHand)
    
    hands.sort(proc (h1, h2: HandData) : int = return CompareHands(h1, h2, CARD_MAP))

    for i in 0..hands.high:
        var currentHand = hands[hands.high-i]
        currentHand.rank = i+1
        totalWinnings += currentHand.rank * currentHand.bid

    echo hands
    echo totalWinnings

proc Part2() =
    var lines = readFile("input.txt").splitLines

    var hands : seq[HandData] = @[]
    var totalWinnings = 0

    for line in lines:
        var lineSplit = line.splitWhitespace
        var newHand = HandData(hand: lineSplit[0], bid: lineSplit[1].parseInt)
        newHand.hType = GetHandTypeWithWildCard(newHand)
        hands.add(newHand)
    
    hands.sort(proc (h1, h2: HandData) : int = return CompareHands(h1, h2, CARD_MAP_WILDCARD))

    for i in 0..hands.high:
        hands[hands.high-i].rank = i+1
        var currentHand = hands[hands.high-i]
        totalWinnings += currentHand.rank * currentHand.bid

    echo hands
    echo totalWinnings

Part1()
Part2()
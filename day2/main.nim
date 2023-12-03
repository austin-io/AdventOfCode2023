import std/strutils
import std/re

proc GetMaxValues(data: seq[string]) : array[3, int] = 
    var result = [0,0,0] 
    
    for batch in data:
        var colors = batch.split(',')

        for color in colors:
            var diceQuantity = findAll(color, re"[0-9]+")[0].parseInt
            #echo diceQuantity

            if("red" in color):
                result[0] = max(result[0], diceQuantity)
            if("green" in color):
                result[1] = max(result[1], diceQuantity)
            if("blue" in color):
                result[2] = max(result[2], diceQuantity)

    result


proc Part1(maxRed, maxGreen, maxBlue: int) = 
    let fileData = open("input.txt")
    defer: fileData.close()

    var i = 1
    var sum = 0

    for line in fileData.lines:
        var gameData = split(line, ": ")
        var roundData = gameData[1].split(';')

        var maxValues = GetMaxValues(roundData)

        if not (maxValues[0] > maxRed or maxValues[1] > maxGreen or maxValues[2] > maxBlue):
            sum += i

        i += 1
    
    echo sum

proc Part2(maxRed, maxGreen, maxBlue: int) = 
    let fileData = open("input.txt")
    defer: fileData.close()

    var i = 1
    var sum = 0

    for line in fileData.lines:
        var gameData = split(line, ": ")
        var roundData = gameData[1].split(';')

        var maxValues = GetMaxValues(roundData)

        sum += maxValues[0] * maxValues[1] * maxValues[2]
    
    echo sum

Part1(12, 13, 14)
Part2(12, 13, 14)

import std/strutils
import std/sequtils
import std/re

proc Part1() = 
    var lines = readFile("input.txt").splitLines

    var sum = 0

    for line in lines:
        var splitData = line.split(": ")
        var stringData = splitData[1]
        var dataSplit = stringData.split(" | ")
        var winningStr = dataSplit[0]
        var currentStr = dataSplit[1]
        var winningNumbers = winningStr.split().filter(proc(s:string) : bool = s != "").map(proc(s: string): int = s.parseInt())
        var currentNumbers = currentStr.split().filter(proc(s:string) : bool = s != "").map(proc(s: string): int = s.parseInt())

        var score = 0
        for currentNum in currentNumbers:
            if(winningNumbers.contains(currentNum)):
                if(score == 0): score = 1
                else: score *= 2
        
        sum += score

    echo sum

proc Part2() =
    var lines = readFile("input.txt").splitLines
    var cardCopies : seq[int] = @[]
    var sum = 0

    for i,_ in lines:
        cardCopies.add(1)

    for i,line in lines:
        var splitData = line.split(": ")
        var stringData = splitData[1]
        var dataSplit = stringData.split(" | ")
        var winningStr = dataSplit[0]
        var currentStr = dataSplit[1]
        var winningNumbers = winningStr.split().filter(proc(s:string) : bool = s != "").map(proc(s: string): int = s.parseInt())
        var currentNumbers = currentStr.split().filter(proc(s:string) : bool = s != "").map(proc(s: string): int = s.parseInt())

        var nextId = i+1

        for currentNum in currentNumbers:
            if(nextId >= cardCopies.len):
                break
            
            if(winningNumbers.contains(currentNum)):
                cardCopies[nextId]+= 1 * cardCopies[i]
                nextId+=1
    

    for v in cardCopies:
        sum += v

    echo sum

Part1()
Part2()
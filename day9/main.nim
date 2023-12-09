import std/strutils
import std/sequtils

proc Part1() =
    var lines = readFile("input.txt").splitLines
    var sum = 0

    for line in lines:
        var histories : seq[seq[int]] = @[]
        var inputStream = line.splitWhitespace.map(proc(x: string):int=x.parseInt)
        histories.add(inputStream)

        var currentStream = inputStream

        while(currentStream.any(proc(x:int):bool= x!=0)):
            var newStream : seq[int] = @[]
            for i in countup(1,currentStream.high):
                newStream.add(currentStream[i] - currentStream[i-1])
            
            histories.add(newStream)
            currentStream = newStream
        
        var lastPrediction = 0
        for i in countdown(histories.high-1, 0):
            var history = histories[i]
            lastPrediction = lastPrediction + history[history.high]
        
        sum += lastPrediction
    
    echo sum

Part1()
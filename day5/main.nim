import std/algorithm
import std/strutils
import std/sequtils
import std/tables
import std/sets
import std/re

const MAX_NUMBER : int = toInt(high(int)/2)

type 
    MapData = object
        ranges: seq[(int, int, int)]
        srcName: string
        destName: string

proc GetMaps(lines: seq[string]) : Table[string, MapData] =
    var maps : Table[string, MapData]

    var currentMap = ""

    for i in 2..lines.high:
        var line = lines[i]
        if(line.isEmptyOrWhitespace): continue
        
        if(line.contains("map:")):
            var newMapSplit = line.split(" map:")[0]
            var sourceDestSplit = newMapSplit.split("-to-")
            currentMap = sourceDestSplit[0]
            maps[currentMap] = MapData(ranges: @[], srcName: currentMap, destName: sourceDestSplit[1])
            continue

        var ranges = line.splitWhitespace().map(proc(s: string): int = s.parseInt())
        maps[currentMap].ranges.add((ranges[0], ranges[1], ranges[2]))
    
    return maps

proc CreateNegativeRanges(map: var Table[string, MapData]) = 
    for k,v in map:
        var newRanges : seq[(int, int, int)] = @[]
        var newSourceIndex = -MAX_NUMBER

        for r in map[k].ranges:
            var rangeSize = r[1] - newSourceIndex
            var rangeEnd = r[1] + r[2]
            if(rangeSize > 0):
                newRanges.add((newSourceIndex, newSourceIndex, rangeSize))

            newSourceIndex = rangeEnd

        newRanges.add((newSourceIndex, newSourceIndex, MAX_NUMBER - newSourceIndex))

        map[k].ranges = concat(newRanges, map[k].ranges)

proc CheckRanges(r1, r2: (int, int, int)) : bool =
    return r1[0] <= r2[1]+r2[2] and r1[0]+r1[2] >= r2[1]

proc CheckPointInRange(p: int, r: (int, int)) : bool =
    return r[0] <= p and r[1] >= p

proc ApplyRanges(mapData: MapData, ranges: seq[(int, int, int)]) : seq[(int, int, int)] =
    
    var result : seq[(int, int, int)] = @[] 
    
    for r1 in ranges:
        for r2 in mapData.ranges:
            # check for range overlap
            if(not CheckRanges(r1, r2)):
                continue

            # splice ranges
            var (r1Start, r1End, r2Start, r2End) = (r1[0], r1[0]+r1[2], r2[1], r2[1]+r2[2])
            var diff = r2[0] - r2[1]
            var minRange = max(r1Start, r2Start)
            var maxRange = min(r1End, r2End)
            if(maxRange-minRange <= 0): continue
            result.add((minRange+diff, minRange, maxRange-minRange))
            
    return result

proc GetLowestLocation(maps: Table[string, MapData], seeds: seq[int]) =
    
    var lowestKeyValue = MAX_NUMBER

    for seed in seeds:
        var currentMap = "seed"
        var currentKey = seed

        while currentMap != "location":
            #echo currentMap, ": ", currentKey
            var found = false
            for mapRange in maps[currentMap].ranges:
                var sourceRange = (mapRange[1], mapRange[1] + mapRange[2])
                var destRange = (mapRange[0], mapRange[0] + mapRange[2])
                
                if(CheckPointInRange(currentKey, sourceRange)):
                    #echo "Found: ", mapRange, sourceRange, destRange
                    currentKey = (currentKey - sourceRange[0]) + destRange[0]
                    currentMap = maps[currentMap].destName
                    found = true
                    break             
            
            if(not found):
                #echo "Not Found"
                currentMap = maps[currentMap].destName
        
        echo seed, ": ", currentKey
        lowestKeyValue = min(lowestKeyValue, currentKey)
    
    echo lowestKeyValue

proc GetLowestLocationRange(maps: Table[string, MapData], seeds: seq[(int, int)]) =
    
    var lowestKeyValue = MAX_NUMBER

    for seed in seeds:
        var currentMapKey = "seed"
        var inputRanges : seq[(int, int, int)] = @[(seed[0], seed[0], seed[1])]
        var currentLow = MAX_NUMBER

        while currentMapKey != "location":
            echo currentMapKey, ": ", inputRanges
            inputRanges = ApplyRanges(maps[currentMapKey], inputRanges)
            currentMapKey = maps[currentMapKey].destName
    
        for r in inputRanges:
            currentLow = min(currentLow, r[0])

        lowestKeyValue = min(lowestKeyValue, currentLow)

    echo lowestKeyValue

proc Part1() = 
    var lines = readFile("input.txt").splitLines
    var maps = GetMaps(lines)
    var seeds = lines[0].split("seeds: ")[1].splitWhitespace.map(proc(s: string): int = s.parseInt())
    
    GetLowestLocation(maps, seeds)
        
proc Part2() =
    var lines = readFile("input.txt").splitLines
    var maps = GetMaps(lines)

    for k,v in maps:
        maps[k].ranges.sort(proc(r1,r2: (int, int, int)) : int = cmp(r1[1], r2[1]))
    
    CreateNegativeRanges(maps)
    
    for k,v in maps:
        maps[k].ranges.sort(proc(r1,r2: (int, int, int)) : int = cmp(r1[1], r2[1]))

    var seedRanges = lines[0].split("seeds: ")[1].splitWhitespace.map(proc(s: string): int = s.parseInt())
    var seeds: seq[(int, int)] = @[]

    for i in countup(1, seedRanges.high-1, 2):
        var seedStart = seedRanges[i-1]
        var seedRange = seedRanges[i]
        seeds.add((seedStart, seedRange))

    GetLowestLocationRange(maps, seeds)

#Part1()
Part2()
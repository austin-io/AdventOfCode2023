import std/strutils
import std/re
import tables

type
    NumberDef = object
        value: int
        str: string
        xId: int
        yId: int   

proc CheckPerimeter(lines: seq[string], num: NumberDef) : bool =
    for y in num.yId-1..num.yId+1:

        if(y < 0 or y >= lines.len): 
            continue

        for x in num.xId-1..num.xId+num.str.len:
            if(x < 0 or x >= lines[y].len): 
                continue

            if(not lines[y][x].isDigit and lines[y][x] != '.'):
                return true
    
    return false

proc FindStars(lines: seq[string], num: NumberDef) : seq[(int, int)] =
    
    var result : seq[(int, int)]
    
    for y in num.yId-1..num.yId+1:

        if(y < 0 or y >= lines.len): 
            continue

        for x in num.xId-1..num.xId+num.str.len:
            if(x < 0 or x >= lines[y].len): 
                continue

            if(lines[y][x] == '*'):
                result.add((x,y))
    
    return result

proc FindAllWithIndexes(str: string, reg: Regex) : seq[(string, int)] =
    var result : seq[(string, int)]

    var foundMatches = findAll(str, reg)

    var startId = 0
    for match in foundMatches:
        var i = find(str, reg, startId)
        startId = i + match.len
        result.add((match, i))

    return result

proc GetNumbers(lines: seq[string]) : seq[NumberDef] = 
    var result : seq[NumberDef]
    
    for y,line in lines:
        var matches = FindAllWithIndexes(line, re"([0-9]+)")

        for match in matches:
            var (str, id) = match
            var num = NumberDef(value: str.parseInt(), str: str, xId: id, yId: y)
            result.add(num)

    return result

proc Part1() = 
    var lines = readFile("input.txt").splitLines
    var numbers = GetNumbers(lines)
    
    var sum = 0
    for num in numbers:
        if(CheckPerimeter(lines, num)):
            sum += num.value
    
    echo sum

proc Part2() =
    var lines = readFile("input.txt").splitLines
    var numbers = GetNumbers(lines)
    var starMap = initTable[(int,int), seq[int]]()
    var sum = 0

    for y,line in lines:
        for x,c in line:
            if(c == '*'):
                starMap[(x,y)] = @[]

    for num in numbers:
        var stars = FindStars(lines, num)
        for star in stars:
            starMap[(star[0], star[1])].add(num.value)

    for key, value in starMap:
        if(value.len != 2): continue
        sum += value[0] * value[1]
    
    echo sum

proc main() = 
    Part1()
    Part2()

main()
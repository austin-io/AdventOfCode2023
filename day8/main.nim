import std/algorithm
import std/sequtils
import std/strutils
import std/tables
import std/math

type 
    NodeData = object
        sequence: Table[(string, int), int]
        endpoints: seq[(string, int)]

proc Part1() =
    var lines = readFile("input.txt").splitLines

    var pattern: seq[int] = @[]
    for c in lines[0]:
        if(c == 'L'):
            pattern.add(0)
        else:
            pattern.add(1)
    
    var maps: Table[string, seq[string]]
    
    for i in countup(2, lines.high):
        var line = lines[i]
        var key = line.split(" = ")[0]
        var values = line.split(" = ")[1]
        var leftHand = (values.split(", ")[0])[1..3]
        var rightHand = (values.split(", ")[1])[0..2]
        maps[key] = @[leftHand, rightHand]
    
    var currentPatternIndex = 0
    var currentKey = "AAA"
    var steps = 0
    while(currentKey != "ZZZ"):
        if(currentPatternIndex > pattern.high):
            currentPatternIndex = 0
        var idx: int = pattern[currentPatternIndex]
        var pair = maps[currentKey]
        currentKey = pair[idx]
        echo currentKey
        currentPatternIndex += 1
        steps += 1
    
    echo steps

proc NodesComplete(nodes: seq[string]) : bool =
    return not nodes.any(proc(n: string) : bool = n[2] != 'Z')

proc Part2() =
    var lines = readFile("input.txt").splitLines

    var pattern: seq[int] = @[]
    for c in lines[0]:
        if(c == 'L'):
            pattern.add(0)
        else:
            pattern.add(1)
    
    var maps: Table[string, seq[string]]
    for i in countup(2, lines.high):
        var line = lines[i]
        var key = line.split(" = ")[0]
        var values = line.split(" = ")[1]
        var leftHand = (values.split(", ")[0])[1..3]
        var rightHand = (values.split(", ")[1])[0..2]
        maps[key] = @[leftHand, rightHand]

    var currentNodes: seq[string] = @[]
    var nodeDataList: seq[NodeData] = @[]
    for k,v in maps:
        if(k[2] == 'A'):
            currentNodes.add(k)

    var loopLengths: seq[int] = @[]

    for node in currentNodes:
        var nd = NodeData()
        var pId = 0
        var nextNode = node
        var i = 0

        echo "Start: ", node
        while(true):
            echo nextNode, pId

            if(nextNode[2] == 'Z'):
                if(nd.endpoints.contains((nextNode, pId))):
                    echo "Length: ", i-nd.sequence[(nextNode, pId)]
                    loopLengths.add(i-nd.sequence[(nextNode, pId)])
                    break
                
                nd.sequence[(nextNode, pId)] = i
                nd.endpoints.add((nextNode, pId))
            
            nextNode = maps[nextNode][pattern[pId]]

            pId += 1
            i += 1
            if(pId > pattern.high):
                pId = 0
        
        nodeDataList.add(nd)

    echo lcm(loopLengths)

Part1()
Part2()
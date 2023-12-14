import std/strutils
import std/tables

type
    Direction = enum
        North, East, South, West

const pipes = {
    '|': [North, South],
    '-': [East, West],
    'L': [North, East],
    'F': [East, South],
    '7': [South, West],
    'J': [West, North]
}.toTable

type
    MapNode = object
        shape: char
        directions: tuple[first: Direction, second: Direction]
        position: tuple[x: int, y: int]

proc FlipDirection(dir: Direction): Direction =
    case dir:
        of North:
            return South
        of South:
            return North
        of East:
            return West
        of West:
            return East

proc ConnectNeighbour(lines:seq[string], pos: (int, int), dir: Direction) : MapNode =
    var neighbours: seq[char] = @[]
    var positions: seq[(int, int)] = @[]
    var (x,y) = pos

    var neighbourPos = pos
    
    case dir:
        of North:
            neighbourPos[1] -= 1
        of South:
            neighbourPos[1] += 1
        of East:
            neighbourPos[0] += 1
        of West:
            neighbourPos[0] -= 1
    
    var neighbourShape = lines[neighbourPos[1]][neighbourPos[0]]

    var result = MapNode(shape: neighbourShape, position: neighbourPos)

    if(pipes.hasKey(neighbourShape)):
        result.directions = (pipes[neighbourShape][0], pipes[neighbourShape][1])
    
    return result

proc StartConnections(lines: seq[string], start: MapNode) : (MapNode, seq[MapNode]) =
    
    var resultMap: seq[MapNode] = @[]
    var resultNode = MapNode()
    var neighbours: seq[char] = @[]
    var positions: seq[(int, int)] = @[]
    var directions: seq[Direction] = @[]
    var (x,y) = start.position
    
    if(y > 0): 
        neighbours.add(lines[y-1][x])
        positions.add((x, y-1))
        directions.add(North)
    if(y < lines.high): 
        neighbours.add(lines[y+1][x])
        positions.add((x, y+1))
        directions.add(South)
    if(x > 0): 
        neighbours.add(lines[y][x-1])
        positions.add((x-1, y))
        directions.add(West)
    if(x < lines[0].high): 
        neighbours.add(lines[y][x+1])
        positions.add((x+1, y))
        directions.add(East)
    
    var idx = 0
    for i in 0..neighbours.high:
        var dir = directions[i]
        var flippedDir = FlipDirection(dir)
        var neighbour = neighbours[i]
        
        if(not pipes.hasKey(neighbour)): continue
        
        var dirs = pipes[neighbour]
        if(dirs.contains(flippedDir)):
            if(idx == 0): resultNode.directions.first = dir
            else: resultNode.directions.second = dir

            idx += 1
            resultMap.add(MapNode(
                    shape: neighbour, 
                    directions: (dirs[0], dirs[1]),
                    position: positions[i]))
    
    return (resultNode, resultMap)

proc GetOther(pipe: MapNode, dir: Direction): Direction =
    if(pipe.directions.first == dir): return pipe.directions.second
    return pipe.directions.first

proc PipeContains(pipe: MapNode, dir: Direction): bool =
    return pipe.directions.first == dir or pipe.directions.second == dir

proc BuildMap(lines: seq[string]) : seq[MapNode] =
    var result : seq[MapNode] = @[]
    var startingPoint: MapNode

    # find starting point
    for y in 0..lines.high:
        var line = lines[y]
        var found = false
        
        for x in 0..line.high:
            var c = line[x]
            if(c == 'S'):
                startingPoint = MapNode(shape: c, position: (x,y))
                found = true
                break
        
        if(found):
            break

    var (startData, startingNodes) = StartConnections(lines, startingPoint)
    startingPoint.directions = startData.directions
    result.add(startingPoint)

    var nextNode = startingPoint
    var nextDir = nextNode.directions.first

    while(true):
        nextNode = ConnectNeighbour(lines, nextNode.position, nextDir)
        if(nextNode.shape == 'S'):
            break
        nextDir = GetOther(nextNode, FlipDirection(nextDir))
        result.add(nextNode)

    return result


proc Part1() =
    var lines = readFile("input.txt").splitLines

    var map = BuildMap(lines)

    echo map.len / 2

Part1()
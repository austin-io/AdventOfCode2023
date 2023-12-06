proc CalcDistance(holdTime, totalTime: int): int =
    return holdTime * (totalTime-holdTime)

proc Part1() =
    var times = @[62,64,91,90]
    var distances = @[553,1010,1473,1074]

    var product = 1

    for i in 0..times.high:
        var time = times[i]
        var distance = distances[i]

        echo "Race ", i+1, ": Time(", time, ") | Distance(", distance, ")"

        var minHold = 0
        var maxHold = 0
        for holdTime in 0..time:
            var travelDistance = CalcDistance(holdTime, time)
            if(travelDistance > distance):
                echo "Found: ", holdTime, " | ", travelDistance
                minHold = holdTime
                break
        
        for holdTime in countdown(time, 0):
            var travelDistance = CalcDistance(holdTime, time)
            if(travelDistance > distance):
                echo "Found: ", holdTime, " | ", travelDistance
                maxHold = holdTime
                break

        var winMargin = maxHold - minHold + 1
        echo winMargin
        product *= winMargin
    
    echo product

Part1()
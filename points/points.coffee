baseAttributes =
    Wildwood:
        Strength:      14
        Vitality:      13
        Dexterity:     18
        Intelligence:  17
        Mind:          12
        Piety:         16
    Duskwight:
        Strength:      15
        Vitality:      14
        Dexterity:     15
        Intelligence:  18
        Mind:          15
        Piety:         13
    Highlander:
        Strength:      18
        Vitality:      17
        Dexterity:     15
        Intelligence:  13
        Mind:          15
        Piety:         12
    Midlander:
        Strength:      16
        Vitality:      15
        Dexterity:     14
        Intelligence:  16
        Mind:          13
        Piety:         16
    Plainsfolk:
        Strength:      13
        Vitality:      13
        Dexterity:     17
        Intelligence:  16
        Mind:          15
        Piety:         16
    Dunesfolk:
        Strength:      12
        Vitality:      12
        Dexterity:     15
        Intelligence:  16
        Mind:          17
        Piety:         18
    Seeker:
        Strength:      16
        Vitality:      15
        Dexterity:     17
        Intelligence:  13
        Mind:          14
        Piety:         15
    Keeper:
        Strength:      13
        Vitality:      12
        Dexterity:     16
        Intelligence:  14
        Mind:          18
        Piety:         17
    Wolf:
        Strength:      17
        Vitality:      18
        Dexterity:     13
        Intelligence:  12
        Mind:          16
        Piety:         14
    Hellsguard:
        Strength:      15
        Vitality:      16
        Dexterity:     12
        Intelligence:  15
        Mind:          17
        Piety:         15

baseElements =
    Wildwood:
        Fire:          12
        Water:         15
        Lightning:     14
        Wind:          18
        Earth:         17
        Ice:           14
    Duskwight:
        Fire:          14
        Water:         16
        Lightning:     15
        Wind:          12
        Earth:         17
        Ice:           16
    Highlander:
        Fire:          15
        Water:         13
        Lightning:     18
        Wind:          14
        Earth:         14
        Ice:           16
    Midlander:
        Fire:          16
        Water:         16
        Lightning:     15
        Wind:          15
        Earth:         15
        Ice:           13
    Plainsfolk:
        Fire:          14
        Water:         15
        Lightning:     17
        Wind:          15
        Earth:         16
        Ice:           13
    Dunesfolk:
        Fire:          17
        Water:         12
        Lightning:     15
        Wind:          16
        Earth:         18
        Ice:           12
    Seeker:
        Fire:          18
        Water:         17
        Lightning:     12
        Wind:          13
        Earth:         15
        Ice:           15
    Keeper:
        Fire:          13
        Water:         14
        Lightning:     16
        Wind:          15
        Earth:         14
        Ice:           18
    Wolf:
        Fire:          13
        Water:         18
        Lightning:     13
        Wind:          17
        Earth:         12
        Ice:           17
    Hellsguard:
        Fire:          18
        Water:         15
        Lightning:     14
        Wind:          16
        Earth:         13
        Ice:           14

statCaps = [
      0
     30,  32,  34,  36,  38,  40,  42,  44,  46,  50
     52,  54,  56,  60,  62,  64,  68,  70,  72,  76
     78,  82,  84,  88,  90,  94,  96, 100, 102, 106
    108, 112, 116, 118, 122, 126, 128, 132, 136, 140
    142, 146, 148, 152, 156, 160, 162, 166, 170, 174
]

pointsAvailable = [
      0
      0,   4,   9,  14,  20,  26,  32,  38,  44,  52
     60,  68,  76,  84,  92, 100, 108, 116, 124, 132
    142, 152, 162, 174, 186, 198, 212, 226, 240, 256
    272, 288, 306, 324, 342, 362, 382, 402, 424, 446
    468, 492, 516, 540, 566, 592, 618, 646, 674, 702
]

$ = (x) ->
    document.getElementById(x)

setBaseValues = ->
    race = $('Race').value
    for attr, value of baseAttributes[race]
        $(attr).value = value
    for ele, value of baseElements[race]
        $(ele).value = value
    return

validateRank = ->
    @value = 50 if isNaN(@value) or not (1 <= @value <= 50)
    updateRemaining()
    return

validateAllotment = ->
    race = $('Race').value
    base = baseAttributes[race][@id] if @id of baseAttributes[race]
    base = baseElements[race][@id] if @id of baseElements[race]
    @value = base if isNaN(@value) or @value < base
    updateRemaining()
    return

updateRemaining = ->
    rank = $('Rank').value
    race = $('Race').value
    pointsStart = pointsAvailable[rank]

    attrPoints = pointsStart
    for input in $('Attributes').getElementsByTagName('input')
        unless input.disabled
            base = baseAttributes[race][input.id]
            attrPoints -= getPointCost(input.value, base)
    $('RA').value = attrPoints

    elePoints = pointsStart
    for input in $('Elements').getElementsByTagName('input')
        unless input.disabled
            base = baseElements[race][input.id]
            elePoints -= getPointCost(input.value, base)
    $('RE').value = pointsStart
    return

selectOnFocus = ->
    this.select()
    return

init = ->
    setBaseValues()
    updateRemaining()

    $('Race').onchange = setBaseValues
    $('Rank').onchange = validateRank
    $('Rank').onfocus = selectOnFocus

    for input in $('Attributes').getElementsByTagName('input')
        unless input.disabled
            input.onchange = validateAllotment
            input.onfocus = selectOnFocus
    for input in $('Elements').getElementsByTagName('input')
        unless input.disabled
            input.onchange = validateAllotment
            input.onfocus = selectOnFocus
    return

getPointCost = (x, base) ->
    cost = 0
    points = x
    if points > 128
        cost += 4*(points-128)
        points = 128
    if points > 80
        cost += 3*(points-80)
        points = 80
    if points > 40
        cost += 2*(points-40)
        points = 40
    cost += points-base
    return cost
    

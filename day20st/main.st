Object subclass: Node [
    | value following next prev |
    append: node [
        following ifNil: [following := node].
        next follows: node.
        node precedes: next.
        node follows: self.
        self precedes: node.
        ^node
    ]

    follows: node [prev := node.]

    precedes: node [next := node.]

    followedBy: node [following := node]

    value [^value]

    setValue: v [value := v.]

    move: n forward: i [
        i = 0 ifTrue: [prev append: n.] ifFalse: [next move: n forward: i-1.]
    ]

    move: n back: i [
        i = 0 ifTrue: [self append: n.] ifFalse: [prev move: n back: i-1.]
    ]

    next [^next]

    shiftOver: size [
        |steps|
        next follows: prev.
        prev precedes: next.
        steps := value rem: (size-1).
        (steps < 0)
          ifTrue: [prev move: self back: (0-steps)]
          ifFalse: [next move: self forward: steps].
        ^following
    ]
]

Object subclass: GroveFile [
    |head size|
    contents: a [
        |tail|
        head := Node new.
        head precedes: head.
        head follows: head.
        tail := head.
        size := 0.
        a do: [:v | tail := tail append: (Node new setValue: v). size := size + 1].
        head := head next.
        tail followedBy: head.
        tail precedes: head.
        head follows: tail.
    ]

    mix [
        |curr|
        curr := head.
        1 to: size do: [:i|curr := curr shiftOver: size].
    ]

    coordinateSum [
        |curr sum|
        curr := head.
        [(curr value == 0) not] whileTrue: [curr := curr next].
        1 to: 1000 do: [:i|curr := curr next].
        sum := curr value.
        1 to: 1000 do: [:i|curr := curr next].
        sum := curr value + sum.
        1 to: 1000 do: [:i|curr := curr next].
        ^curr value + sum
    ]
]

Object subclass: Aoc [
    inputData [
        |f a|
        f := FileStream open: 'input.txt' mode: FileStream read.
        a := f lines contents collect: [:x | x asNumber].
        f close.
        ^a
    ]
    part1 [
        |file|
        file := GroveFile new contents: (self inputData).
        file mix.
        ^file coordinateSum
    ]
    part2 [
        |file|
        file := GroveFile new contents: ((self inputData) collect: [:i| i * 811589153]).
        1 to: 10 do: [:i| file mix].
        ^file coordinateSum
    ]
    run: part [
        ^part = 'part2'
            ifTrue: [^self part2]
            ifFalse: [^self part1]
    ]
]

aoc := Aoc new.
part := Smalltalk getenv: 'part'.
answer := aoc run: part.
answer printOn: stdout.
Transcript cr.

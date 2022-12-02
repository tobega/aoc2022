Object subclass: Strategy [
    | elf you |
    from: spec [
        elf := 'ABC' indexOf: (spec at: 1).
        you := 'XYZ' indexOf: (spec at: 3).
        ^self
    ]

    shape [
        ^#(1 2 3) at: you
    ]

    play [
        | result |
        result := (you - elf + 3) \\ 3 + 1.
        ^(#(3 6 0) at: result) + (self shape)
    ]

    forceResult [
        you := ((#(2 0 1) at: you) + (elf - 1)) \\ 3 + 1.
        ^self
    ]
]

Object subclass: Aoc [
    inputData [
        |f a|
        f := FileStream open: 'input.txt' mode: FileStream read.
        a := f lines contents collect: [:x | Strategy new from: x].
        f close.
        ^a
    ]
    part1 [
        ^self inputData inject: 0 into: [:sum :a | sum + (a play)]
    ]
    part2 [
        ^self inputData inject: 0 into: [:sum :a | sum + (a forceResult play)]
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

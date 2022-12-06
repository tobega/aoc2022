Object subclass: Search [
    | end check |
    endUnique: length in: a [
        end := length.
        check := 1.
        [check < end] whileTrue: [
            |i|
            i := check + 1.
            [i <= end] whileTrue: [
                ((a at: i) = (a at: check))
                ifTrue: [
                    end := check + length.
                    check := check + 1.
                    i := check + 1.
                ]
                ifFalse: [
                    i := i + 1.
                ]
            ].
            check := check + 1.
        ].
        ^end.
    ]
]

Object subclass: Aoc [
    inputData [
        |f a|
        f := FileStream open: 'input.txt' mode: FileStream read.
        a := f nextLine.
        f close.
        ^a
    ]
    part1 [
        ^Search new endUnique: 4 in: (self inputData)
    ]
    part2 [
        ^Search new endUnique: 14 in: (self inputData)
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

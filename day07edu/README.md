# Day 7 three ways
Many people had trouble with the [day 7](https://adventofcode.com/2022/day/7) problem. Paradoxically, good developers probably had more trouble. Here some of the difficulties are explained and implementations are provided in imperative, functional and OO styles, written in the [Tailspin programming language](https://github.com/tobega/tailspin-v0).

The first possible problem for good developers concerns what you can assume about the exploratory session in the file system. Is it a rational pre-order depth-first search? Or did you go back and forth a bit? Did you do `ls` more than once on a directory?

## Imperative
If you assume the rational depth-first search, this works very well as a rather simple imperative program, running the commands from the session and mutating data as you go to build a tree and collect the sizes. See the [file `imperative.tt`](imperative.tt)

Good developers generally try to avoid the imperative style (even if really good developers probably have again understood that it sometimes is appropriate). Consider what happens with your code if you have to deal with the possibility of `ls` being called twice in a directory, or if you can leave and come back and continue exploring. What if you redundantly explored the same directory twice? For example, changing `subdirs` to be a map instead of a list would mean also changing code in the solution parts.

## Functional
When trying to express this algorithm in a functional way, things can become a little awkward. For example, for an `ls` you need to collect up the resulting list before returning it, and you don't know you're done before the next command (or end of file) comes. Then you need to return the next command with the file list so it can be processed in the calling function instead. In Tailspin, you can return multiple values, while in a more mainstream functional language you would probably return a tuple with the result and the next command.

Building a tree can also be awkward because you receive higher level data before the lower level data, so you need to keep track of the upside-down tree until you can build it right.

It might be a better plan to keep track of a flat list of directories with their absolute paths and collect things up later. Another reason to do this is that it if the data structures change in a functional language, a lot of code needs to change, so the data structures should be as accurate and simple as possible. An advantage of this approach is that the only thing depended upon is the `ls` command being run at least once in each directory with files in it (at least, if we filter out duplicates). It is illustrated in the [file `functional.tt`](functional.tt)

## Object-oriented (OO)
To object-orient it is not enough to slap getters and setters on your data types, whatever any C++ programmer or Java Enterprise Architect might tell you. You can use the object mechanism to create abstract datatypes that fit with your imperative program, but when you fully object-orient, the objects should provide complete services to you, like [actors](https://en.wikipedia.org/wiki/Actor_model) or perhaps the context and interactions of [DCI](https://en.wikipedia.org/wiki/Data,_context_and_interaction)

Here in the [file `OO.tt`](OO.tt) we have a Directory object that can build itself and its tree from a provided CommandBuffer. Then it can, through the `dirSizes` message, provide a list of directory names and sizes, with its own name and size as the first data structure.

The OO solution also simply assumes the rational depth-first search as the imperative. The difference is that any work done to reduce assumptions will be invisible to the users of the object, they continue to work as before.

open System

type Instruction = | Noop | Addx of int
exception UnknownInstruction of string

let parseInstruction instruction =
  match instruction with
  | "noop" -> Noop
  | s when s.StartsWith "addx" -> Addx(Array.get (s.Split " ") 1 |> int)
  | s -> raise (UnknownInstruction(s))

let scan collector append instructions =
  let rec doScan collector cycle x instructions =
    match instructions with
    | [] -> collector
    | Noop :: T -> doScan (collector |> append cycle x) (cycle+1) x T
    | Addx v :: T -> doScan (collector |> append cycle x |> append (cycle+1) x) (cycle+2) (x+v) T
  doScan collector 1 1 instructions

let sample cycle x collector =
  if (cycle - 20) % 40 = 0 then
    collector + cycle * x
  else
    collector

let solutionPart1 instructions =
  scan 0 sample instructions

let draw cycle x collector =
  let hpos = (cycle - 1) % 40
  collector
    + if x-1 <= hpos && hpos <= x+1 then "#" else "."
    + if cycle % 40 = 0 then "\n" else ""
  
let solutionPart2 instructions =
  scan "\n" draw instructions

[<EntryPoint>]
let main argv =
    let input = (System.IO.File.ReadLines("input.txt")
        |> Seq.map parseInstruction |> Seq.toList)

    printfn "%s" (
        match Environment.GetEnvironmentVariable("part") with
        | null | "part1" -> solutionPart1 input |> string
        | "part2" -> solutionPart2 input |> string
        | env -> $"Unknown value {env}"
    )
    0 // return an integer exit code
app [main] { pf: platform "../platform/main.roc" }

import pf.Stdout

# This example demonstrates the use of `Task.result`.
# It transforms a task that can either succeed with `ok`, or fail with `err`, into
# a task that succeeds with `Result ok err`.
main =
    when checkFile "good" |> Task.result! is
        Ok Good -> Stdout.line "GOOD"
        Ok Bad -> Stdout.line "BAD"
        Err IOError -> Stdout.line "IOError"

checkFile : Str -> Task [Good, Bad] [IOError]
checkFile = \str ->
    if str == "good" then
        Task.ok Good
    else if str == "bad" then
        Task.ok Bad
    else
        Task.err IOError

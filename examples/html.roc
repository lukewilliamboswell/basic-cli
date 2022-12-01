app "html"
    packages { pf: "../src/main.roc" }
    imports [
        pf.Process,
        pf.Stdout,
        pf.Stderr,
        pf.Task.{ Task },
        pf.File,
        pf.Path,
        pf.Html.{html, h1, text},
    ]
    provides [main] to pf


path = Path.fromStr "out.html"
renderTask = File.writeUtf8 path (Html.renderStatic view)

main : Task {} []
main =
    Task.attempt renderTask \result ->
        when result is
            Ok _ -> 
                {} <- Stdout.line "Success" |> Task.await
                Process.exit 0
            Err _ -> 
                {} <- Stderr.line "Fail" |> Task.await
                Process.exit 1

view =
    html 
        [] 
        [h1 [] [text "The Roc Tutorial"]]

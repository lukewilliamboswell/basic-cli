interface Html.Internal
    exposes [
        Html,
        Attribute,
        element,
        text,
        none,
        appendRenderedStatic,
        nodeSize,
    ]
    imports []

# TODO: maybe we should have two separate types for  and unrendered views?
# App code would only ever deal with the unrendered type. Diff is between old  and new unrendered
Html : [
    None,
    Text Str,
    Element Str Nat (List (Attribute)) (List (Html)),
]

Attribute : [
    HtmlAttr Str Str,
    Style Str Str,
]

# -------------------------------
#   VIEW FUNCTIONS
# -------------------------------
## Define an HTML Element
element : Str -> (List (Attribute), List (Html) -> Html)
element = \tagName ->
    \attrs, children ->
        # While building the node tree, calculate the size of Str it will render to
        withTag = 2 * (3 + Str.countUtf8Bytes tagName)
        withAttrs = List.walk attrs withTag \acc, attr -> acc + attrSize attr
        totalSize = List.walk children withAttrs \acc, child -> acc + nodeSize child

        Element tagName totalSize attrs children

text : Str -> Html
text = \content -> Text content

none : Html
none = None

nodeSize : Html -> Nat
nodeSize = \node ->
    when node is
        Text content -> Str.countUtf8Bytes content
        Element _ size _ _ -> size
        None -> 0

attrSize : Attribute -> Nat
attrSize = \attr ->
    when attr is
        HtmlAttr key value -> 4 + Str.countUtf8Bytes key + Str.countUtf8Bytes value
        Style key value -> 4 + Str.countUtf8Bytes key + Str.countUtf8Bytes value

# -------------------------------
#   STATIC HTML
# -------------------------------
appendRenderedStatic : Str, Html -> Str
appendRenderedStatic = \buffer, node ->
    when node is
        Text content ->
            Str.concat buffer content

        Element name _ attrs children ->
            withTagName = "\(buffer)<\(name)"
            withAttrs =
                if List.isEmpty attrs then
                    withTagName
                else
                    init = { buffer: Str.concat withTagName " ", styles: "" }
                    { buffer: attrBuffer, styles } =
                        List.walk attrs init appendRenderedStaticAttr

                    if Str.isEmpty styles then
                        attrBuffer
                    else
                        "\(attrBuffer) style=\"\(styles)\""

            withTag = Str.concat withAttrs ">"
            withChildren = List.walk children withTag appendRenderedStatic

            "\(withChildren)</\(name)>"

        None -> buffer

appendRenderedStaticAttr : { buffer : Str, styles : Str }, Attribute -> { buffer : Str, styles : Str }
appendRenderedStaticAttr = \{ buffer, styles }, attr ->
    when attr is
        HtmlAttr key value ->
            newBuffer = "\(buffer) \(key)=\"\(value)\""

            { buffer: newBuffer, styles }

        Style key value ->
            newStyles = "\(styles) \(key): \(value);"

            { buffer, styles: newStyles }
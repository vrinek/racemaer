([.[][0]] | max) as $max0 |
([.[][1] | length] | max) as $max1 |
([.[][2:][]] | max) as $maxdist |
[
    .[] | [
        .[0] / $max0,
        .[1] / $max1,
        .[2:][] / $maxdist
    ]
]

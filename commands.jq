[
    .[] | if length == 0 then
        [0,0,0,0]
    else [.[].action] as $actions | [
        if $actions | contains(["accelerate"]) then 1 else 0 end,
        if $actions | contains(["turn_left"]) then 1 else 0 end,
        if $actions | contains(["turn_right"]) then 1 else 0 end,
        if $actions | contains(["brake"]) then 1 else 0 end
    ]
    end
]

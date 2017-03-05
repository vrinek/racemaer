## input

- human player
- AI
- scripted performance
- "twitch plays"

## input // device

- mouse
- keyboard
- gamepad
- touch
- voice
- gesture

## input // network

- remote player

## input // gameplay

- commands pattern

## gameplay // storage

- level design
- entity behaviours
- entity stats

## gameplay // progress

- store state
- restore state

## progress // storage

- save game to disk
- load game from disk

## progress // network

- share score
- leaderboards

## gameplay // presentation

- model-view pattern

## presentation // storage

- assets initialization

## presentation // device

- display graphics
- play audio
- force feedback
- twitch

# Solitaire example

- gameplay is classic card game rules
    - mostly deterministic
    - random shuffle at beginning of game
- input may be:
    - touch
    - mouse
    - keyboard
    - voice
    - gestures
    - twitch plays
- presentation may be:
    - 2d graphics
    - 3d graphics
    - VR
    - voice
    - streaming video service

# Chess example

- gameplay is classic board game rules
    - fully deterministic
- gameplay // storage may handle:
    - starting positions
- input may be:
    - touch
    - mouse
    - keyboard
    - voice
    - gestures
    - twitch plays
- 2nd player input may be:
    - AI
    - network
    - local
- presentation may be:
    - 2d graphics
    - 3d graphics
    - VR
    - voice
    - streaming video service

# Fighting game example

- gameplay is something like mortal kombat
    - mostly/fully deterministic
- gameplay // storage may handle:
    - character stats/moves
    - location behaviours
    - player generated content (characters, costumes, arenas)
- input may be:
    - touch
    - mouse
    - keyboard
    - voice
    - gestures
    - twitch plays
- 2nd player input may be:
    - AI
    - network
    - local
- presentation may be:
    - 2d graphics
    - 3d graphics
    - VR
    - voice
    - streaming video service
- progress may handle:
    - unlocked content (characters, costumes, arenas)
    - leaderboards

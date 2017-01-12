# Racer Maker

You are a racing teacher. You're teaching an AI how to drive and win the championship.

## TODO

### Part 1: racing game

- [ ] Car
    - [x] Forward motion
    - [x] Turning
    - [x] Braking
    - [ ] Reverse
        - [x] Go reverse
        - [ ] Steer reverse
- [ ] Race track
    - [x] Sprites
        - [x] Road
        - [x] Background
    - [ ] Physics _via Chipmunk_
        - [x] Barriers
        - [ ] Tarmac Vs Sandtraps friction
- [ ] Gameplay
    - [ ] Recognise laps
        - [x] Implement checkpoints
        - [x] Define _flag_ checkpoint
        - [ ] Incrementally activate next checkpoint
        - [ ] Detect going backwards (and disable checkpoints)
    - [ ] Recognise victory _(3 laps?)_
    - [x] Keep time
- [ ] UI
    - [ ] Menus
        - [ ] Track select
        - [ ] Pause menu
        - [ ] Game over
    - [ ] HUD
        - [ ] Speed
        - [ ] Lap time
- [ ] Graphics
    - [ ] Camera
    - [ ] Drift marks
    - [ ] Dust particles
- [ ] Sounds
    - [ ] Vroom-vroom
    - [ ] Drift screech
    - [ ] Brake screech
    - [ ] Collision thump

### Part 2: AI teaching game

- [ ] Sensors
- [ ] Connect with tensorflow
- [ ] AI learning
    - [ ] Mimic
        - [ ] Learn on every lap
        - [ ] Online learning
    - [ ] Pain/happiness learning

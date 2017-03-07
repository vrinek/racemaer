# Racer Maker

You are a racing teacher. You're teaching an AI how to drive and win the championship.

## Install

This project assumes you have the following installed:

* Ruby 2.4 (with bundler)
* Python 3.6 (with virtualenv)

To get the ruby game setup:

```
cd game
bundle install
cd ..
```

To get the python machine learning project setup:

```
cd machine-learning
pip install -r requirements.txt
cd ..
```

## Usage

```
cd game
bundle exec ruby game.rb record
# Run a few laps.
# Press Q to quit.

fish send_to_train.fish
cd ../machine-learning
python train.py
mv parameters.json ../game/parameters.json
cd ../game

bundle exec ruby game.rb ai
```

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

- [x] Sensors
- [ ] Connect with tensorflow
    - [x] Via manual process
    - [ ] Via automated process
    - [ ] Via sockets
- [ ] AI learning
    - [x] Mimic
        - [x] Play, train, run
        - [ ] Learn on every lap
        - [ ] Online learning (learn while running)
    - [ ] Pain/happiness learning

## Architectural notes

```
[keyboard] -> [Input] -> [Gameplay] -> [Presenter] -> [window]
```

When recording:

```
[keyboard] -> [HumanInput] -> [InputRecorder] -> [Gameplay] ...
```

When replaying:

```
[InputReplayer] -> [Gameplay] ...
```

AI sensors:

```
... [Gameplay] -> [HumanPresenter] -> [window]
               -> [SensorsPresenter] -> [filesystem]
```

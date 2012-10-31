This is a collection of utilities related to the AR drone

## Augmentation

drone augmentation can be found in lib/droner.coffee

#### events

Adds landed, landing, hovering, flying, batteryChange, and altitudeChange events to the drone. Being pulled into ar-drone core so will be removed

#### batteryLevel(cb)

returns battery level to callback

#### safeguard

disables emergency mode on start and adds error handles to prevent your app from crashing and having your drone fly off into space

#### record(loc)

Records raw video data to location (HD with higher framerate)

You'll need to run ```ffmpeg -i recording.h264 -vcodec copy recording.mp4``` to convert it into an mp4. record will append video to your existing one so you can keep a log of your drone's entire history easily

#### enableControls(speed=0.5)

Adds controls via stdin to the drone - look below for these

#### enableFacialRecognition

Adds a processing step to PNG frames for running facial recognition. drone.faces will emit a data event with a PNG buffer that has circles drawn around faces


## Controller

Depends on opencv for facial recognition

Run ```coffee face.coffee``` to control the drone from the command line with WASD

Controls:

```
w - forward
a - left
s - backward
d - right

arrow up - up
arrow left - spin left
arrow down - down
arrow right - spin right

<space> - land/takeoff
x - hover
r - disable emergency mode
1/2 - flipAhead/flipLeft
```

You can view the camera from localhost:8080


## Installing node on the drone

Requires that vagrant and virtualbox be installed (thanks felixge for doing the hard parts on this)

Run

```
npm run-script build
npm run-script install
```
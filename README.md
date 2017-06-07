# wiggles-then-notes

## Dependencies
This project is developed using the [Eclipse IDE](https://eclipse.org/downloads/).

Additionally, it requires:
* [Processing](https://github.com/processing/processing/releases/tag/processing-0243-3.0b5) for the graphics
* [oscP5](http://www.sojamo.de/libraries/oscP5/) for the OSC messages
* [theMidiBus](http://www.smallbutdigital.com/themidibus.php) for the MIDI messages
* [peasyCam](http://mrfeinberg.com/peasycam/) for the 3D rotations

The versions of these libraries that were used for the development of this project are included in the ```lib``` folder

## TODO
- Ability to mask a viz using arbitrary image files
- Read overlays from 'overlays' folder cycle through them via OSC/MIDI
- Move the assignment of sliders to values out of the "update" function and into a function that only runs when the sliders are being manipulated. Otherwise the slider values override any incoming MIDI/OSC values.
- Hard-code note 48 to trigger the 'wave' lissajous
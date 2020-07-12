<img src="https://github.com/kittywhiskers/ramen/blob/master/misc/extras/logo256.png" width="200" style="display: block; margin-left: auto; margin-right: auto; width: 50%;" />

# ramen

A repository featuring data-moshing methods by using data degradation and Digital Signal Processing.

```
Copyright (c) 2020 Kittywhiskers Van Gogh

Any media assets made available from the official repository 
(https://github.com/kittywhiskers/ramen) are licensed under the 
Creative Commons Attribution-ShareAlike 4.0 International License
unless specified otherwise.

Any script, program, binary or source code made available from the 
official repository (https://github.com/kittywhiskers/ramen) 
is licensed under the MIT License unless specified otherwise.
```

## Content Used

- `assets/8000x4500.png` - [Wikimedia Commons - World of glitch HQ OpenCL 8K 20200628.png by PantheraLeo1359531](https://commons.wikimedia.org/wiki/File:World_of_glitch_HQ_OpenCL_8K_20200628.png), available under the Creative Commons CC0 1.0 Universal Public Domain Dedication.
- `assets/3355x4671.png` - [Wikimedia Commons - Seagate Microdrive Actuator, Arm, Read Write Head and Platter (8572304253).png by Dennis van Zuijlekom](https://commons.wikimedia.org/wiki/File:Seagate_Microdrive_Actuator,_Arm,_Read_Write_Head_and_Platter_%288572304253%29.png), available under the Creative Commons Attribution-Share Alike 2.0 Generic license.
- `assets/3755x2816.png` - [Wikimedia Commons - Young blonde woman vaping.png by Jörg Schubert](https://commons.wikimedia.org/wiki/File:Young_blonde_woman_vaping.png), available under the the Creative Commons Attribution 2.0 Generic license.
- `assets/2493x3096.png` - [Wikimedia Commons - MatsumotoShunsuke Cityscape 1939 Feb.png, a reproduction of Matsumoto Shunsuke's now public domain works](https://commons.wikimedia.org/wiki/File:MatsumotoShunsuke_Cityscape_1939_Feb.png), available under [potentially restrictive terms](https://commons.wikimedia.org/wiki/Commons:Reuse_of_PD-Art_photographs) depending on jurisdiction.
- `assets/misc/logo*.png` - A modified version of [The Creative Exchange's](https://www.thecreativeexchange.co) [photograph of ramen on Unsplash](https://unsplash.com/photos/YRSRQpBfsj4), **this photo is not available under CC-BY-SA 4.0**

## Directories

### Using only scripts [[originals](https://github.com/kittywhiskers/ramen/releases/tag/scpt), [hq](https://github.com/kittywhiskers/ramen/tree/master/results/scpt)]

- **`results/scpt/sdpth*`: degradation from conversion from `png` to `wav` and back**
- `results/scpt/lconv0`: degradation from conversion from `png` to `mp3` and back
- **`results/scpt/lconv1:` degradation from conversion from `png` to `ogg` and back**
- `results/scpt/lconv2`: degradation from conversion from `png` to `au` and back

### Using external utilities [[originals](https://github.com/kittywhiskers/ramen/releases/tag/dsp), [hq](https://github.com/kittywhiskers/ramen/tree/master/results/dsp)]

Uses the Ableton Live 10 Suite 10.1.2, using the `wav` verb in-script. **Promising results are highlighted in bold.**

#### Using external plugins:

- **`results/dsp/flgcv`: changes introduced by applying flanger (using kHs Flanger)**
- `results/dsp/bchcv`: changes introduced by applying bitcrushing (using kHS Bitcrush) 
- **`results/dsp/cbfcv`: changes introduced by applying a comb filter (using MeldaProduction MComb)**
- `results/dsp/pcfcv`: changes introduced by applying pitch correction (using MeldaProduction MAutoPitch) 
- **`results/dsp/pcfcv`: changes introduced by bit manipulation (using MeldaProduction MBitFun)** 
- **`results/dsp/krscv`: changes introduced by a glitch plugin (using Tritik Krush)** 
- **`results/dsp/crwcv`: changes introduced by [Crow's VR PHAT RACK](https://www.youtube.com/watch?v=AOvtHlG0ens) (which utilises Ableton Stock Plugins)**
- `results/dsp/vamcv`: changes introduced by volume automation (using Xfer's LFOTool @ `1/4, 80bpm`)

#### Using Ableton Live 10 Suite plugins

- `results/dsp/mbccv`: changes introduced by using Multiband Dynamics
- **`results/dsp/btrcv`: changes introduced by using Beat Repeat**
- `results/dsp/crpcv`: changes introduced by using Corpus
- `results/dsp/vcdcv`: changes introduced by using Vocoder
- `results/dsp/rvbcv`: changes introduced by using Reverb
- **`results/dsp/gdycv`: changes introduced by using Delay (Grain)**
- `results/dsp/cbncv`: changes introduced by using Cabinet
- `results/dsp/rdxcv`: changes introduced by using Redux
- `results/dsp/gcmcv`: changes introduced by using Glue Compressor

## Additional notes

- Generating PNG files with `imagemagick`: `find . -type f -name '*.wav' -maxdepth 1 -exec ./ramen.sh wav {} \;`
- Generating WAV files with `ffmpeg`: `find assets -type f -name '*.png' -maxdepth 1 -exec ./ramen.sh png {} \;`
- All the images within `results` were first losslessy compressed with [crunch](https://github.com/chrissimpkins/Crunch) and then files were lossy compressed with [pngquant](https://github.com/kornelski/pngquant) using `find results -type f -name *.png -exec pngquant --nofs --strip --speed 1 --skip-if-larger -- {} \;` to ~~meet Git LFS requirements~~ meet Git requirements (still >1GB but at least no file is >100MB)


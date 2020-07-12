#!/usr/bin/env bash

# request: do not use llf for wavs, it does result in data loss and in general
# less intersting images, use it to only understand patterns (or ignore this
# request in imagemagick won't co-operate, that's why the feature's there!)

COMMAND_VERB="$(echo $1 | tr '[:upper:]' '[:lower:]')"
SOURCE_FILE="$2"
COMPRESSION_CODEC=$3

# png/jpg
Q_DEPTH="32"
# Q_DEPTH="24" (rgb24)

# additional ImageMagick flags
CONV_ADDN_FLAGS="-verbose"
INTERMEDIATE_FORMAT="rgb" # used for wav in dsp

# additional ffmpeg flags
PIX_FORMAT="rgba64le"
# (alternative interesting presets)
# PIX_FORMAT="rgb48le"
# PIX_FORMAT="rgb24"

# wav
S_DEPTH="24" # bit depth 24 creates positive bias towards blue+yellow (sdpth24 and everything else)
# S_DEPTH="16" # bit depth 16 behaves like sdpth32
# S_DEPTH=$Q_DEPTH # this gives you more boring washout (sdpth32 only)
#WAV_KHERTZ="176400" # sample rate (used for wav)
WAV_KHERTZ="44100" # sample rate (used for lossy)
INTEGER_TYPE="unsigned" # int type

# lossy formats
LLF_BITRATE="320" #kbps

if ! [ -x "$(command -v convert)" ] || ! [ -x "$(command -v sox)" ]; then
  echo 'Required applications are absent, quitting :(' >&2
  exit 1
fi

if ! [ -x "$(command -v ffmpeg)" ]; then
  echo 'WARNING: FFMPEG IS MISSING, \"llf\" verb will not work :|' >&2
fi

function print_and_quit {
  echo $1;
  echo "ramen.sh [verb] [filepath]";
  echo "verbs:"; echo "";
  echo "png - convert png to wav";
  echo "pngl- convert png to mp3/lossy format (taken as third argument without period mark)";
  echo "llf - convert lossy audio format to png";
  echo "wav - convert wav to png"; echo "";
  exit 1;
}

function convertImageToWaveFile {
  echo "Converting file \"$1\" to \"$(basename -- "$1" .png).$INTERMEDIATE_FORMAT\" with ImageMagick"
  convert $CONV_ADDN_FLAGS -depth $Q_DEPTH $1 "$(basename -- "$1" .png).$INTERMEDIATE_FORMAT"
  mv "$(basename -- "$1" .png).$INTERMEDIATE_FORMAT" "$(basename -- "$1" .png).raw"
  echo "Converting file \"$1\" to \"$(basename -- "$1" .png)$2\" with sox"
  sox -r $WAV_KHERTZ -e $INTEGER_TYPE -b $S_DEPTH -c 1 "$(basename -- "$1" .png).raw" "$(basename -- "$1" .png)$2"
  mv "$(basename -- "$1" .png).raw" "$(basename -- "$1" .png).$INTERMEDIATE_FORMAT"
}

function convertWaveFileToImage {
  echo "Converting file \"$1\" to \"$(basename -- "$1" $2).raw\" with Sox"
  sox -r $WAV_KHERTZ -e $INTEGER_TYPE -b $S_DEPTH -c 1 "$1" "$(basename -- "$1" $2).raw"
  mv "$(basename -- "$1" $2).raw" "$(basename -- "$1" $2).$INTERMEDIATE_FORMAT"
  echo "Converting file \"$(basename -- "$1" $2).raw\" to \"$(basename -- "$1" $2).png\" with ImageMagick"
  convert $CONV_ADDN_FLAGS -size "$(basename -- "$1" $2)" -depth $Q_DEPTH "$(basename -- "$1" $2).$INTERMEDIATE_FORMAT" "$(basename -- "$1" $2).png"
}

function convertLossyFileToImage {
  echo "Converting file \"$1\" to \"$(basename -- "$1" $2).raw\" with Sox"
  if [ $2 == ".wav" ]; then
    sox -r $WAV_KHERTZ -e $INTEGER_TYPE -b $S_DEPTH -c 1 "$1" "$(basename -- "$1" $2).raw"
  else
    sox -r $WAV_KHERTZ -e $INTEGER_TYPE -b $S_DEPTH -c 1 "$1" -C $LLF_BITRATE "$(basename -- "$1" $2).raw"
  fi
  mv "$(basename -- "$1" $2).raw" "$(basename -- "$1" $2).$INTERMEDIATE_FORMAT"
  echo "Converting file \"$(basename -- "$1" $2).raw\" to \"$(basename -- "$1" $2).png\" with ffmpeg"
  ffmpeg -y -f rawvideo -pixel_format $PIX_FORMAT -video_size "$(basename -- "$1" $2)" -i "$(basename -- "$1" $2).$INTERMEDIATE_FORMAT" -frames:v 1 "$(basename -- "$1" $2).png"
}

export -f convertImageToWaveFile
export -f convertWaveFileToImage
export -f convertLossyFileToImage

if [ -z ${SOURCE_FILE+x} ]; then
  print_and_quit "Source file missing in arguments, quitting!" >&2;
elif ! [ -f "$SOURCE_FILE" ]; then
  print_and_quit "Cannot locate source file or is not a valid file, quitting!" >&2;
fi

# basically, wildcard codec support means i can't add this anymore, kept in case anybody doesn't want nixing other formats
#if [ ${SOURCE_FILE: -4} == ".png" ] || [ ${SOURCE_FILE: -4} == ".mp3" ] || [ ${SOURCE_FILE: -4} == ".wav" ]; then
#  echo "Source file using a supported format ${SOURCE_FILE: -4}, continuing";
#else
#  print_and_quit "Source file not using a supported format, quitting" >&2;
#fi

if [ $COMMAND_VERB == "llf" ]; then
  if [ -x "$(command -v ffmpeg)" ]; then
    INTERMEDIATE_FORMAT="rgb"
  #  convertWaveFileToImage "$SOURCE_FILE" .mp3 # doesn't work, imagemagick doesn't like EOFs
    convertLossyFileToImage "$SOURCE_FILE" ${SOURCE_FILE: -4} # does work, can tolerate EOFs
  else
    print_and_quit "ffmpeg cannot be located, verb disabled, quitting!" >&2;
  fi
elif [ $COMMAND_VERB == "png" ]; then
  convertImageToWaveFile "$SOURCE_FILE" .wav
elif [ $COMMAND_VERB == "pngl" ]; then
  if [ -z ${COMPRESSION_CODEC+x} ]; then
    COMPRESSION_CODEC=".mp3";
  else
    COMPRESSION_CODEC="."$COMPRESSION_CODEC;
  fi
  echo "Using $COMPRESSION_CODEC format for lossy compression";
  INTERMEDIATE_FORMAT="rgb";
  convertImageToWaveFile "$SOURCE_FILE" "$COMPRESSION_CODEC";
elif [ $COMMAND_VERB == "wav" ]; then
  convertWaveFileToImage "$SOURCE_FILE" .wav
else
  print_and_quit "Invalid verb, quitting!" >&2;
fi

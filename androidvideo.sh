#!/bin/bash
####################################################################################
# Name: androidvideo
# Version: 0.2
#
# This script is based on "androidvideo 0.1", a script developed by Harel Malk in May 2009 (http://www.harelmalka.com)
#
# (Modified by): Segundo Luis Martín Díaz Sotomayor
# (Nick): zchronos
# (Website): http://gioscix.com/bishoujolinux/
# (Email): smartinds@gmail.com
#
# IMPORTANT: You need compile ffmpeg with libfaac support
#
# I made this script for my Galaxy Mini GT-S5570L with Android 2.3.5 GingerBread but it works in all android devices
# For low-end smarthphones (for example the Galaxy Mini) I recommend the preset 1 (default: mpeg4)
#
# The other presets are in:
# http://developer.android.com/guide/appendix/media-formats.html
#
# Date: Dec. 12, 2011
#
####################################################################################
NEW_RESOLUTION="0"
PRESET="1"
ASPECT="4:3"
declare -a VIDEO_FILES # array to hold the files to covert

convert () {
    echo "Converting ${1}"
    ffmpeg -y -i "$1" -vcodec "$CODEC" -s "$RESOLUTION" -r "$FRAME_RATE" -b:v "$BITRATE_VIDEO" -acodec libfaac -ac "$AUDIO_CHANNELS" -ab "$AUDIO_BIT_RATE" -aspect "$ASPECT" -f mp4 "${1%.*}_convert.mp4"
}

help () {
    echo "This script is based on \"androidvideo\", a script developed by Harel Malk in May 2009 (http://www.harelmalka.com)"
    echo "The conversion works on Galaxy Mini and others Android models."
    echo "Presets:"
    echo ""
    echo "  1:  mpeg4 in SD (Works very well in all devices)"
    echo "  2:  h.264 in SD (Low Quality)"
    echo "  3:  h.264 in SD (High Quality)"
    echo "  4:  h.264 in HD (Not available on all devices)"
    echo ""
    echo "Options:" 
    echo "  -preset      Preset. Default to 1"
    echo "  -aspect      Aspect. Default to 4:3"
    echo "  -s           Video Resolution (The Default depend from Profile)"
    echo ""
    echo "Examples:"
    echo ""
    echo "  Converting a video with defaults options:"
    echo "  ./androidconvert [FILE]"
    echo ""
    echo "  Converting a video with other options:"
    echo "  ./androidconvert -preset 1 -aspect 4:3 [FILE]"
    echo ""
    echo "  Converting many videos:"
    echo "  ./androidconvert [FILE] [FILE] [FILE]"
    echo ""
}
##############################################################################
# Start 
echo "--------------------------------------------------------------------"
echo "Androvideo2 - The Android video convertor"
echo "Based in the work from Harel Malka"
echo "http://www.harelmalka.com"
echo ""
echo "Modified by zchronos"
echo "http://gioscix.com/bishoujolinux"
echo ""
echo "Usage: androvideo [OPTIONS] [FILE] [FILE]... "
echo "Try: 'androvideo -h' for more help"
echo ""
echo "THERE IS NO WARRANTY WHATSOEVER. USE AT OWN RISK!"
echo "I AM NOT RESPONSIBLE FOR ANY DAMAGE CAUSED TO YOU OR YOUR COMPUTER."
echo "--------------------------------------------------------------------"
echo ""

while [ $# -gt 0 ]; do   
    case "$1" in
        -preset)
            if [ "$2" -lt 5 ] && [ "$2" != 0 ]; then
                PRESET="$2"
                shift
            else
                echo "ERROR: Preset must be 1 - 4"
                exit 0
            fi
            ;; 
        -aspect)
            ASPECT="$2"
            shift
            ;;
        -s)
            NEW_RESOLUTION="$2"
            shift
            ;;
        -h|--help)
            help
            exit 1
            ;;
        * )
            VIDEO_FILES=( "${VIDEO_FILES[@]}" "$1" )
            ;;                      
    esac
    shift
done

case "$PRESET" in
    "1")
        CODEC="mpeg4"
        RESOLUTION="480x360"
        FRAME_RATE="25"
        BITRATE_VIDEO="500k"
        AUDIO_CHANNELS="2"
        AUDIO_BIT_RATE="128k"
        ;; 
    "2")
        CODEC="libx264"
        RESOLUTION="176x144"
        FRAME_RATE="12"
        BITRATE_VIDEO="56k"
        AUDIO_CHANNELS="1"
        AUDIO_BIT_RATE="24k"
        ;;
    "3")
        CODEC="libx264"
        RESOLUTION="480x360"
        FRAME_RATE="30"
        BITRATE_VIDEO="500k"
        AUDIO_CHANNELS="2"
        AUDIO_BIT_RATE="128k"
        ;;
    "4")
        CODEC="libx264"
        RESOLUTION="1280x720"
        FRAME_RATE="30"
        BITRATE_VIDEO="2000k"
        AUDIO_CHANNELS="2"
        AUDIO_BIT_RATE="192k"
        ;;
esac

if [ $NEW_RESOLUTION != "0" ]; then
    RESOLUTION=$NEW_RESOLUTION
fi

# display conversion parameters
echo "Coversion parameters:"
echo "  Video Codec: ${CODEC}"
echo "  Resolution: ${RESOLUTION}"
echo "  Frame Rate: ${FRAME_RATE}"
echo "  Bitrate Video: ${BITRATE_VIDEO}"
echo "  Audio channels: ${AUDIO_CHANNELS}"
echo "  Audio bitrate: ${AUDIO_BIT_RATE}"
echo ""

# perform the conversions
for FILE in "${VIDEO_FILES[@]}"
do
    convert "$FILE"
done
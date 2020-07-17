#!/bin/bash

function print_version() {
	echo "PACKAGE_NAME PACKAGE_VERSION by Richard Bäck"
}

function print_help() {
	print_version

	echo ""
	echo "Usage: $0 <mode> <input-audio-file> <input-sequence-file>"
	echo ""
	echo "Available modes:"
	echo "- A   Each line of the input file is a time stamp in the format hh:mm:ss "
	echo "      (max 24 hours for one time stamp) at which a song ends (except for"
	echo        "the last one."
	echo "      Example:"
	echo "      1:30"
	echo "      2:30"
	echo "      4:20"
	echo "- B   Each line of the input file is the duration of the song in seconds."
	echo "      Example:"
	echo "      95"
	echo "      132"
	echo "      234"

	exit 1;
}

function mode_a() {
	input="$1"
	input_basename=$(basename "$input")
	sequences="$2"

	input_temp=$(echo /tmp/$input_basename.temp)

	cp "$input" "$input_temp"

	last_duration=0
	cur_duration=0
	duration=0
	counter=1
	for seq in $(cat "$sequences"); do
		input_temp_new=$(echo "$input_temp.wav")

		cur_duration=$(date -d "1970-01-01 $seq UTC" +%s)
		duration=$(($cur_duration - $last_duration))

		ffmpeg -t $duration -i "$input_temp" $counter.wav
		ffmpeg -ss $seq -i "$input" "$input_temp_new"
		mv "$input_temp_new" "$input_temp"

		counter=$(($counter + 1))
		last_duration=$cur_duration
	done

	if [[ $last_duration -ne 0 ]]; then
		mv "$input_temp" "$counter.wav"
	fi
}

function mode_b() {
	input="$1"
	sequences="$2"
	input_basename=$(basename "$input")

	input_temp=$(echo /tmp/$input_basename.temp)

	cp "$input" "$input_temp"

	counter=1
	for seq in $(cat "$sequences"); do
		input_temp_new=$(echo "$input_temp.wav")

		ffmpeg -t $seq -i "$input_temp" $counter.wav
		ffmpeg -ss $seq -i "$input_temp" "$input_temp_new"
		mv "$input_temp_new" "$input_temp"

		counter=$(($counter + 1))
	done

	rm "$input_temp"
}

mode=a

while getopts ":vVh" opt; do
	case "$opt" in
		"v" )
			verboseOn=1
			;;
		"V")
			print_version
			exit
			;;
		"h")
			print_help
			exit
			;;
	esac
done

args=( $@ )

case "${args[$OPTIND - 1]}" in
    clean)
        clean
        ;;
    debug)
        debug
        ;;
    * )
        release
        ;;
esac

mode="$1"
input_audio="$2"
input_seq="$3"
case $mode in
	A)
		mode_a "$input_audio" "$input_seq"
		;;
	B)
		mode_b "$input_audio" "$input_seq"
		;;
	*)
		print_help
esac

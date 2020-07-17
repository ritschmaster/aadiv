################################################################################
# This file is part of aadiv.
#
# Copyright 2020 Richard Paul Baeck <richard.baeck@mailbox.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
################################################################################

function print_version() {
	echo "PACKAGE_NAME PACKAGE_VERSION by Richard Bäck <richard.baeck@mailbox.org>"
}

function print_help() {
	print_version

	echo ""
	echo "Usage: $0 [options] <mode> <input-audio-file> <input-sequence-file>"
	echo ""
	echo "Available options:"
	echo "-V  Print version and exit"
	echo "-h  Print this help text and exit"
	echo ""
	echo "Available modes:"
	echo "A   Each line of the input file is a time stamp in the format hh:mm:ss "
	echo "    (max 24 hours for one time stamp) at which a song ends (except for"
	echo      "the last one."
	echo "    Example:"
	echo "    1:30"
	echo "    2:30"
	echo "    4:20"
	echo "B   Each line of the input file is the duration of the song in seconds."
	echo "    Example:"
	echo "    95"
	echo "    132"
	echo "    234"

	exit 1;
}

bin=$0
mode=a
input_audio=''

while getopts ":Vh" opt; do
	case "$opt" in
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

shift $((OPTIND-1))

if [ $# -ne 3 ]; then
	print_help $bin
	exit
fi

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
		print_help $bin
		exit
		;;
esac

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

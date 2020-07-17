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

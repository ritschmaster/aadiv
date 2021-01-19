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
	in_audio_filename="$1"
	in_seq_filenames="$2"
  audio_format="$3"

	in_audio_basename=$(basename "$in_audio_filename")

	in_audio_filename_temp=$(echo /tmp/$in_audio_basename.temp)

	cp "$in_audio_filename" "$in_audio_filename_temp"

	last_duration=0
	cur_duration=0
	duration=0
	counter=1
	for seq in $(cat "$in_seq_filenames"); do
		in_audio_filename_temp_new=$(echo "$in_audio_filename_temp.$audio_format")

		cur_duration=$(date -d "1970-01-01 $seq UTC" +%s)
		duration=$(($cur_duration - $last_duration))

		ffmpeg -t $duration -i "$in_audio_filename_temp" $counter.$audio_format
		ffmpeg -ss $seq -i "$in_audio_filename" "$in_audio_filename_temp_new"
		mv "$in_audio_filename_temp_new" "$in_audio_filename_temp"

		counter=$(($counter + 1))
		last_duration=$cur_duration
	done

	if [[ $last_duration -ne 0 ]]; then
		mv "$in_audio_filename_temp" "$counter.$audio_format"
	fi
}

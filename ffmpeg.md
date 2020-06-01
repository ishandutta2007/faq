#### ffmpeg

##### encode to get better compression ratio

| Browser               | AV1 | H264 | H265 | VP8 | VP9 | AAC | MP3 | VORBIS | OPUS |
|-----------------------|-----|------|------|-----|-----|-----|-----|--------|------|
| Chrome for Desktop    | 70  | 30   | -    | 30  | 30  | 30  | 30  | 30     | 33   |
| Chrome for Android    | -   | 30   | -    | 30  | 30  | 30  | 30  | 30     | -    |
| IE                    | -   | 9    | 101  | -   | -   | 9   | 9   | -      | -    |
| IE Mobile             | -   | 10   | -    | -   | -   | 10  | 10  | -      | -    |
| Edge                  | 75  | 12   | 121  | -   | 142 | 12  | 12  | -      | 14   |
| Firefox for Desktop   | 67  | 22   | -    | 20  | 28  | 22  | 22  | 20     | 20   |
| Firefox for Android   | -   | 20   | -    | 20  | 28  | 20  | 20  | 20     | 20   |
| Safari for Mac        | -   | 3    | 113  | -   | -   | 3   | 3   | -      | -    |
| Safari for iOS        | -   | 3    | 113  | -   | -   | 3   | 3   | -      | -    |
| Opera for Desktop     | 57  | 25   | -    | 11  | 16  | -   | -   | 11     | 12   |
| Android Stock Browser | -   | 2.3  | -    | 4.0 | 5   | 2.3 | 2.3 | 4.0    |      |

Encoding that can be used for video files over the web

    # video can be streamed by all browsers
    for filename in $(ls -1 *mp4)
    do
     ffmpeg -i ${filename} -c:v libx264 -crf 26 ${filename}.26.mp4
    done

##### Google's Recommended Settings


VOD Recommended Settings

    ffmpeg -i <source> -c:v libvpx-vp9 -pass 1 -b:v 1000K -threads 8 -speed 4 \
      -tile-columns 6 -frame-parallel 1 \
      -an -f webm /dev/null
    
    ffmpeg -i <source> -c:v libvpx-vp9 -pass 2 -b:v 1000K -threads 8 -speed 1 \
      -tile-columns 6 -frame-parallel 1 -auto-alt-ref 1 -lag-in-frames 25 \
      -c:a libopus -b:a 64k -f webm out.webm

c:v libvpx-vp9 tells FFmpeg to encode the video in VP9.
c:a libopus tells FFmpeg to encode the audio in Opus.
b:v 1000K tells FFmpeg to encode the video with a target of 1000 kilobits.
b:a 64k tells FFmpeg to encode the audio with a target of 64 kilobits.
Multi-threaded encoding may be used if -threads > 1 and -tile-columns > 0.
Setting auto-alt-ref and lag-in-frames >= 12 will turn on VP9's alt-ref frames, a VP9 feature that enhances quality.
speed 4 tells VP9 to encode really fast, sacrificing quality. Useful to speed up the first pass.
speed 1 is a good speed vs. quality compromise. Produces output quality typically very close to speed 0, but usually encodes much faster.


DASH Recommended Settings

See http://wiki.webmproject.org/adaptive-streaming/instructions-to-playback-adaptive-webm-using-dash for WebM DASH settings.

Best Quality (Slowest) Recommended Settings

    ffmpeg -i <source> -c:v libvpx-vp9 -pass 1 -b:v 1000K -threads 1 -speed 4 \
      -tile-columns 0 -frame-parallel 0 \
      -g 9999 -aq-mode 0 -an -f webm /dev/null
    
    ffmpeg -i <source> -c:v libvpx-vp9 -pass 2 -b:v 1000K -threads 1 -speed 0 \
      -tile-columns 0 -frame-parallel 0 -auto-alt-ref 1 -lag-in-frames 25 \
      -g 9999 -aq-mode 0 -c:a libopus -b:a 64k -f webm out.webm

tile-columns 0, frame-parallel 0: Turning off tile-columns and frame-parallel should give a small bump in quality, but will most likely hamper decode performance severely.

Constant Quality Recommended Settings

Objective is to achieve a constant (perceptual) quality level without regard to bitrate.
(Note that Constant Quality differs from Constrained Quality, described below.)

    ffmpeg -i <source> -c:v libvpx-vp9 -pass 1 -b:v 0 -crf 33 -threads 8 -speed 4 \
      -tile-columns 6 -frame-parallel 1 \
      -an -f webm /dev/null
    
    ffmpeg -i <source> -c:v libvpx-vp9 -pass 2 -b:v 0 -crf 33 -threads 8 -speed 2 \
      -tile-columns 6 -frame-parallel 1 -auto-alt-ref 1 -lag-in-frames 25 \
      -c:a libopus -b:a 64k -f webm out.webm

crf is the quality value (0-63 for VP9). To trigger this mode, you must use a combination of crf <q-value> and b:v 0. bv MUST be 0.

Constrained Quality Recommended Settings

Objective is to achieve a constant (perceptual) quality level as long as the bitrate achieved is below a specified upper bound. Constrained Quality is useful for bulk encoding large sets of videos in a generally consistent fashion.

    ffmpeg -i <source> -c:v libvpx-vp9 -pass 1 -b:v 1400K -crf 23 -threads 8 -speed 4 \
      -tile-columns 6 -frame-parallel 1 \
      -an -f webm /dev/null
    
    ffmpeg -i <source> -c:v libvpx-vp9 -pass 2 -b:v 1400K -crf 23 -threads 8 -speed 2 \
      -tile-columns 6 -frame-parallel 1 -auto-alt-ref 1 -lag-in-frames 25 \
      -c:a libopus -b:a 64k -f webm out.webm

The quality desired is provided as the crf <q-value> parameter and the bitrate upper bound is provided as the b:v <bitrate> parameter, where bitrate MUST be non-zero.
Both crf <q-value> and b:v <bitrate> MUST be provided. In this mode, bitrate control will kick in for difficult videos, where the quality specified cannot be achieved within the given bitrate.
For easy videos, this mode behaves exactly like the constant quality mode, and the actual bitrate achieved can be much lower than the specified bitrate in the b:v parameter.
One caveat in FFMpeg is that if you do not provide the b:v parameter, FFMpeg will assume a default target bitrate of 256K -- so the constrained quality mode will be triggered with a potentially very low target bitrate.



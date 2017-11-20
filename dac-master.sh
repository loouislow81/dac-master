#!/bin/bash
#
# @@script: dac-master.sh
# @@description: Set default DAC, set master volume presets when headphone jack in or out.
# @@author: Loouis Low
# @@copyright: Loouis Low <loouis@gmail.com>
#

# ansi
blue='\e[94m'
nc='\033[0m'
title="${blue}[dac-master]${nc}"

if [ "$1" = "--install" ]
then
	if [ $EUID -ne 0 ]
	then
		echo -e "$title permission denied."
		exit 1
	fi
	if [ ! `which play` ]
	then
		apt -y install sox udev
	fi
	script=`readlink -f $0`
	rulefile=/lib/udev/rules.d/99-usb-audio-auto-select.rules
	if [ -e $rulefile ]
	then
		echo -e "$title udev rule already exists: $rulefile"
	else
		echo -e "$title creating udev rule: $rulefile"
		echo "ACTION==\"add\", SUBSYSTEM==\"usb\", DRIVERS==\"snd-usb-audio\", RUN+=\"$script\"" > $rulefile
		service udev restart
	fi
	rulefile=/usr/lib/pm-utils/sleep.d/99usbaudio
	if [ -e $rulefile ]
	then
		echo -e "$title pm-utils sleep/wake rule already exists: $rulefile"
	else
		echo -e "$title creating pm-utils sleep/wake rule: $rulefile"
		echo -e "#!/bin/sh \n case \"\$1\" in \n 'resume' | 'thaw') \n $script \n ;; \n esac" > $rulefile
		chmod a+x $rulefile
	fi
	exit 0
fi

if [ "$1" = "--sleep" ]
then
	sleep 1
fi

if [ "$UID" == "0" ]
then
	# Check process table for users running PulseAudio
	for user in `ps axc -o user,command | grep pulseaudio | cut -f1 -d' ' | sort | uniq`
	do
		# Fork and relaunch this script as each pulseaudio user
		# tell it to sleep for a second to let pulseaudio install the usb device
		su $user -c "bash $0 --sleep" &
	done
else
	# Use grep to figure out the name of the usb speaker
	speaker=`pacmd list-sinks | grep 'name:' | grep usb | sed 's/.*<//g;s/>.*//g;' | head -n 1`
	# Use grep to figure out the name of the usb microphone
	mic=`pacmd list-sources | grep 'name:' | grep input | grep usb | sed 's/.*<//g;s/>.*//g;' | head -n 1`

	if [ "z$speaker" != "z" ]
	then
		# use this speaker
		pacmd  set-default-sink "$speaker" | grep -vE 'Welcome|>>> $'
		# unmute
		pacmd  set-sink-mute "$speaker" 0 | grep -vE 'Welcome|>>> $'
		# Set the volume.  20000 is 20%
		pacmd  set-sink-volume "$speaker" 20000 | grep -vE 'Welcome|>>> $'
	fi

	if [ "z$mic" != "z" ]
	then
		# use this microphone
		pacmd  set-default-source "$mic" | grep -vE 'Welcome|>>> $'
		# unmute
		pacmd  set-source-mute "$mic" 0 | grep -vE 'Welcome|>>> $'
		# Set the volume.  80000 is 80%
		pacmd  set-source-volume "$mic" 80000 | grep -vE 'Welcome|>>> $'
	fi

	#play a sound to let you know that it was plugged in
	play /usr/share/sounds/speech-dispatcher/test.wav 2> /dev/null
fi

exit 0

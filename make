#!/bin/bash

if [ -z $1 ]
then
	sudo cp notes /usr/bin/notes
	sudo chmod +x /usr/bin/notes
	cp notes.config $HOME/.config/notes.config
	echo "Happy Hacking!"
elif [ $1 = "unistall" ]
then
	if [ -f "/usr/bin/notes" ]
	then
		sudo rm /usr/bin/notes
	fi
	if [ -f "~/notes.db" ]
	then
		rm ~/notes.db
	fi
	if [ -f "~/.config/notes.config" ]
	then
		rm ~/.config/note.config
	fi
	
	echo "Done."
fi


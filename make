#!/bin/bash

if [ -z $1 ]
then
	sudo cp notes /usr/bin/notes
	sudo chmod +x /usr/bin/notes
	cp notes.config $HOME/.config/notes.config
	echo "Happy Hacking!"
elif [ $1 = "unistall" ]
then
	sudo rm /usr/bin/notes
	rm ~/notes.db
	rm ~/.config/note.config
	echo "Done."
fi


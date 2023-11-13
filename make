#!/bin/bash

if [ -z $1 ]
then
	sudo cp notes /usr/bin/notes
	sudo chmod +x /usr/bin/notes
	echo "Happy Hacking!"
elif [ $1 = "uninstall" ]
then
	sudo rm /usr/bin/notes
	rm ~/notes.db
	echo "Done."
fi


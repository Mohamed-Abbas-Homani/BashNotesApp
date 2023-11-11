#!/bin/bash

#needed commands: sqlite3 notify-send xclip espeak

#Add source notes.sh in the ~/.bashrc file

function notes() #main function
{
	createNotesTable
	
	if [ -z $1 ] #listing notes
	then
		if [ "`count`" = "0" ]
		then
			recho "Empty ! Use notes add or notes --help."
			return
		fi
		getNotes | while IFS= read -r line;
		do
			bluto "$i- $line"
			bluto "-------------------------------"
			i=$((i+1))
		done
		
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "add" ] #adding notes with two ways
	then
		if [ -z $2 ] #first by notes add
		then
			recho "Write your note ^^"
			read  note
		else		#second by notes add ...
			shift
			note="$@"
		fi
		insertNote "$note"
		recho "Added ^^"
		notes
		
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "edit" ] #editing notes
	then
		if [ -z $2 ]
		then
			echo "Missing arguments (note number) :("
			return
		fi
		noteToEdit="`noteByNum $2`"
		if [ -z $3 ]
		then
			recho "Write your new note ^^"
			read  newNote
		else	
			shift;shift;
			newNote="$@"
		fi
		sqlite3 notes.db "UPDATE notes SET content = '$newNote' WHERE content = '$noteToEdit';"
		recho "Edited ^^"
		notes
		
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "delete" ] #deleting some or one note
	then
		if [ -z $2 ] 
		then
			echo "Missing arguments (note number) :("
			return
		fi
		getNotes > ".tmp"
		shift
		for i in $@
		do
			noteToDelete=`head -n$i .tmp | tail -n1`
			sqlite3 notes.db "DELETE FROM notes WHERE content = '$noteToDelete';"
		done
		rm ".tmp"
		recho  "Delted ^^"
		notes
	
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "search" ] #searching some or one note
	then
		if [ -z $2 ] 
		then
			echo "Missing arguments (keyword) :("
			return
		fi
    		sqlite3 notes.db "SELECT content FROM notes WHERE content LIKE '%$2%';" | while IFS= read -r line
    		do
    			bluto "$i- $line"
			bluto "-------------------------------"
			i=$((i+1))
    		done
			
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "import" ] #including notes from a file
	then
		if [ -z $2 ] 
		then
			echo "Missing file name :("
			return
		fi
		if [ -f $2 ]
		then
			while IFS= read -r line;
			do
				insertNote "$line"
			
			done < $2
			recho "Imported ^^"
		else
			recho "Invalid file name :("
		fi
		notes
		
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "clear" ] #deleting all notes
	then
		if [ "$2" = "before" ] #keeping today's notes
		then
			sqlite3 notes.db "DELETE FROM notes WHERE date(timestamp) != date('now', 'localtime');"
		else			#clear all
			sqlite3 notes.db "DELETE FROM notes;"
		fi
		if [ -f "tmp.html" ]
		then
			rm "tmp.html"
		fi
		recho "Notes deleted ^^"
		
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "web" ] #display the note on the browser
	then
		echo "<ol>" > "tmp.html"
		getNotes | while IFS= read -r line;
		do
			if [ "$2" = "links" ] #as links
			then
				echo "<li><a href=$line >$line</a></li>" >> "tmp.html" 
			else		      #as normal text
				echo "<li>$line</li>" >> tmp.html 
			fi
		done 
		echo "</ol>" >> "tmp.html"
		firefox "tmp.html"
		
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "remind" ] #creating note reminder
	then
		if ! command -v notify-send &> /dev/null
		then
			recho "notify-send needed :("
		fi
		if [ -z $2 ] || [ -z $3 ]
		then
			echo "Missing arguments (note number or seconds number) :("
			return
		fi
		if [ "$3" -lt 3 ]
		then
			recho "Time too short :(, try more than 3 seconds :)"
			return
		fi
		if [ "$4" = "run" ]
		then
			(sleep $3 && notify-send "note $2 running" && `$(noteByNum $2)` &> /dev/null )&
		else
			(sleep $3 && notify-send "`noteByNum $2`" &> /dev/null )&
		fi
		recho "Done ^^"

	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "speak" ] #creating note reminder
	then
		if command -v espeak &> /dev/null
		then
			if [ "`count`" = "0" ]
			then
				espeak -s 130 "Empty ! Use note add, or help." &> /dev/null
				return
			fi
			getNotes | while IFS= read -r line;
			do
				espeak -s 130 "$i, $line." &> /dev/null 
				i=$((i+1))
			done
		else
			recho "espeak needed :("
		fi

	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "export" ] #export the notes to a file
	then
		if [ -z $2 ]
		then
			echo "Missing arguments (file name) :("
			return
		fi
		getNotes > `"$2"`
		recho "$2 notes copy created ^^"
		
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "copy" ] #export the notes to a file
	then
		if ! command -v xclip &> /dev/null
		then
			recho "xclip needed :("
		fi
		if [ -z $1 ]
    		then
       			 echo "Missing arguments (note number) :("
        		return
    		fi
    		noteToCopy="`noteByNum $2`"
    		echo -n "$noteToCopy" | xclip -selection clipboard
    		recho "Copied to clipboard ^^"
		
	#-------------------------------------------------------------------------------------------------------- 
	elif [ "$1" = "--help" ] #help
	then
		recho "use notes for listing notes"
		recho "use notes add to add new notes"
		recho "use notes delete nb-note to delete a note"
		recho "use notes edit nb-note new-note to edit a note"
		recho "use notes clear to delete all notes, add before to delete all notes without today's notes"
		recho "use notes web to see the notes on firefox and links to them as links"
		recho "use notes import fileName to include a notes file each note on a line"
		recho "use notes export to export the notes to a file"
		recho "use notes remind nb-note nb-seconds to set reminder of a note, add run to run the note"
		recho "use notes search keywords to search for one or more notes"
		recho "use notes copy nb-note to copy the note to the clipboard"
		recho "use notes speak to listen to the notes"
		
	#-------------------------------------------------------------------------------------------------------- 
	else 			#invalid options
		recho "Invalid option :(, use notes help"
	fi
}

function bluto() #echo with blue color
{
	echo -e "\e[34m$@\e[0m"
}

function recho() #echo with red color
{
	echo -e "\e[31m$@\e[0m"
}

function createNotesTable() #Create the notes table if not exist
{
	sqlite3 notes.db "CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY, content TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP);"
}

function getNotes() #get all notes
{
	sqlite3 notes.db "SELECT content FROM notes;" 
}

function insertNote() #insert single note
{
	note="$@"
	sqlite3 notes.db "INSERT INTO notes (content) VALUES ('$note');"
}

function noteByNum() #get note content by its number
{
	getNotes | head -n$1 | tail -n1
}

function count()
{
    sqlite3 notes.db "SELECT COUNT(*) FROM notes;"
}

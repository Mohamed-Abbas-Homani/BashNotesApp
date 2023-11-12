
# Bash Notes App

Bash Notes App is a simple command-line tool for managing notes in your terminal. It provides features like adding, editing, deleting, searching, and more, all within your Bash environment.

## Features

- **List Notes:** View a list of all your notes in the terminal.
- **Add Note:** Add a new note interactively or through command-line arguments.
- **Edit Note:** Modify the content of an existing note.
- **Delete Note:** Remove one or more notes by specifying their numbers.
- **Search Notes:** Search for notes containing specific keywords.
- **Import Notes:** Include notes from a file, with each note on a separate line.
- **Clear Notes:** Delete all notes or keep only today's notes.
- **View on Browser:** Display notes on a browser, either as plain text or clickable links.
- **Set Reminders:** Create reminders for specific notes with optional delay and execution.
- **Read Aloud:** Listen to your notes using the espeak tool.
- **Export to File:** Save your notes to a file for backup or sharing.
- **Copy to Clipboard:** Copy a specific note to the clipboard.

## Prerequisites

Ensure the following commands are available on your system:
- `sqlite3`
- `notify-send`
- `xclip`
- `espeak`

## Installation

1. Run the make file after cloning:

    ```bash
    bash make
    bash make unistall #to unistall
    ```

2. Save and restart your terminal or run `source ~/.bashrc`.

## Usage

```bash
# List all notes
notes

# Add a new note
notes add "Your new note"
or just
notes add

# Edit a note
notes edit 1 "Updated note content"
or just
notes edit 1

# Delete a note
notes delete 2
and you can
notes delete 2 4 1

# Search for notes
notes search "keyword"

# Import notes from a file
notes import notes.txt

# Clear all notes
notes clear
and you can
notes clear before

# View notes on the browser
notes web
and you can
notes web links

# Set reminder
notes remind 1 30
and you can
notes remind 1 30 run

#Read notes aloud
notes speak

#Export to file
notes export notes.txt

#Copy to Clipboard
notes copy 1

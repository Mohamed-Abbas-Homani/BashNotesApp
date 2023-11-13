
# Bash Notes App (Light)

Bash Notes App (Light) is a simple command-line tool for managing notes in your terminal. It provides features like adding, editing, deleting, all within your Bash environment.

## Features

- **List Notes:** View a list of all your notes in the terminal.
- **Add Note:** Add a new note interactively or through command-line arguments.
- **Edit Note:** Modify the content of an existing note.
- **Delete Note:** Remove one or more notes by specifying their numbers.
- **Auto Check Update:** Check for new update and update within the app!
  
## Prerequisites

Ensure the following command is available on your system:
- `sqlite3`
  
## Installation

1. Run the make file after cloning:

    ```bash
    bash make
    bash make uninstall #to uninstall
    ```

## Usage

```bash
# List all notes
notes
or
notes -l

# Add a new note
notes -a "Your new note"

# Edit a note
notes -e 1 "Updated note content"

# Delete a note
notes -d 2
and you can
notes -d 2 4 1
and you can
notes -da #delete all.

#Update
notes -u

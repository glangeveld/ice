# Interactive Command Executor (ice)

This Python program reads command lines one-by-one from a file and executes these command lines on request. For this purpose itruns a loop with the following steps:

1. Wait for the Enter key to be pressed
2. Show the command line that will be executed
3. Wait for the Enter key to be pressed
4. Execute the command line
5. Show shell prompt ('$' or '#') for the next command
6. Go to step 1

Instead of pressing the Enter key for step 1 or 4, key 'q' can be pressed to finish this program immediately in a proper way.

In case of step 4 key 's' can be pressed to skip the command that has been shown.

The only command line argument for this program is the name of the file that contains the command lines to be executed.

When a command line in this file is preceded by a '!' it will be executed using 'sudo sh -c' (so with root privileges). For this purpose it is advised to configure password-less sudo.

When a line in this file starts with a '.' a red dot will be displayed for two seconds to indicate that a special action is required (e.g. showing results via another program during a demo).

When a line in this file starts with a '#' it is skipped (comment). Also empty lines are skipped.

Gerlof Langeveld -- October 2024

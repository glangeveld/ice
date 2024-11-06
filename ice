#!/usr/bin/env python3

################################################################
# Interactive Command Executor -- ice
#
# This program reads command lines one-by-one from a file and
# executes these command lines on request. For this purpose it
# runs a loop with the following steps:
#
# 1. Wait for the Enter key to be pressed
# 2. Show the command line that will be executed
# 3. Wait for the Enter key to be pressed
# 4. Execute the command line
# 5. Show shell prompt ('$' or '#') for the next command
# 6. Go to step 1
#
# Instead of pressing the Enter key for step 1 or 4, key 'q'
# can be pressed to finish this program immediately in a 
# proper way.
# In case of step 4 key 's' can be pressed to skip the command
# that has been shown.
#
# The only command line argument for this program is the name
# of the file that contains the command lines to be executed.
#
# When a command line in this file is preceded by a '!' it
# will be executed using 'sudo sh -c' (so with root privileges). 
# For this purpose it is advised to configure password-less
# sudo.
#
# When a line in this file starts with a '.' a red dot will be
# displayed for two seconds to indicate that a special action
# is required (e.g. showing results via another program during
# a demo).
#
# When a line in this file starts with a '#' it is skipped
# (comment). Also empty lines are skipped.
# --------------------------------------------------------------
# Gerlof Langeveld -- October 2024
#
# This file is free software.  You can redistribute it and/or modify
# it under the terms of the GNU General Public License (GPL); either
# version 3, or (at your option) any later version.
################################################################

import os
import sys
import time
import termios
import subprocess

TYPINGDELAY = 0.03
SETRED      = '\033[31m'
RESETRED    = '\033[0m'


def main():
    # verify that proper name of command file is passed
    #
    if len(sys.argv) != 2:
        sys.exit("Usage: ice cmdfile")

    # open command file
    #
    try:
        f = open(sys.argv[1])
    except Exception:
        sys.exit("cannot open file "+sys.argv[1])

    # set terminal in canonical mode to be able
    # to react on any key pressure
    #
    setcanon()

    # clear screen
    #
    os.system('clear')

    # main loop: read every command line from file
    #
    for cmdline in f:
        # skip empty lines and lines that start with '#' (comment)
        #
        if not cmdline.strip():
            continue

        if cmdline[0] == '#':
            continue

        # when line starts with '.' a red dot
        # will be displayed to indicate that an external
        # program has be be used first
        #
        if cmdline[0] == '.':
            print(f"{SETRED}•{RESETRED}", flush=1, end='')
            time.sleep(2)
            print(f"\b", end='')
            continue

        # when command line starts with '!' the command has to be
        # executed with root privileges
        #
        if cmdline[0] == '!':
            # show relevant prompt: #
            #
            print("#", end=' ', flush=True)

            # prepare execution using sudo 
            #
            cmdline = cmdline.strip('! \n')
            cmdexec = "sudo sh -c '" + cmdline + "'"
        else:
            # show relevant prompt: $
            #
            print("$", end=' ', flush=True)

            cmdline = cmdline.strip()
            cmdexec = cmdline

        # wait for Enter key to be pressed before showing command line
        #
        while True:
            key = sys.stdin.read(1)

            if key == '\n':		    # continue and show command line
                break

            if key == 'q':	    	# stop entire command sequence
                print()
                resetcanon()
                sys.exit()

        # show command line character by character
        #
        for c in cmdline:
            print(c, end='', flush=True)
            time.sleep(TYPINGDELAY)

        # wait for Enter key to be pressed to activate command
        # or 's' to be pressed to skip this command
        #
        while True:
            key = sys.stdin.read(1)     # block until one key pressed

            if key == '\n':		        # execute command
                print()

                comp = subprocess.run(cmdexec, shell=True)

                # if comp.returncode != 0:
                #     print('command failed!', file=sys.stderr)

                break

            elif key == 's':	    	# skip command
                print()
                break

            elif key == 'q':	    	# stop entire command sequence
                print()
                resetcanon()
                sys.exit()

        print()     # empty line after command output


    # terminate program
    #
    print()
    resetcanon()


def setcanon():
    '''
    Set the terminal in cbreak mode with echoing and buffering
    disabled in the terminal driver.
    '''
    global old, fd

    fd = sys.stdin.fileno()       # get filedescriptor of stdin

    old = termios.tcgetattr(fd)   # get current terminal settings
                                  # to be restored at the end

    new = termios.tcgetattr(fd)   # get current terminal settings
                                  # to be modified to change settings

    # modify the new settings: switch off echoing and
    # switch off canonical mode (buffering in terminal driver)
    #
    new[3] &= ~termios.ECHO & ~termios.ICANON

    termios.tcsetattr(fd, termios.TCSANOW, new)        # change settings


def resetcanon():
    '''
    Undo the modification of the terminal by restoring
    the original settings.
    '''
    termios.tcsetattr(fd, termios.TCSADRAIN, old)


try:
    main()
except KeyboardInterrupt:
    resetcanon()

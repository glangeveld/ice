# Interactive Command Executor (`ice`)

Simple Python program that reads command lines one-by-one from a file and executes these command lines on request. It is especially convenient to use this program for command-based demonstrations.

The program executes a loop with the following steps:

1. Wait for the Enter key to be pressed
2. Show the command line that will be executed
3. Wait for the Enter key to be pressed
4. Execute the command line
5. Show shell prompt ('`$`' or '`#`') for the next command
6. Go to step 1

Instead of pressing the Enter key for step 1 or 3, key '`q`' can be pressed to finish this program immediately in a proper way.

In case of step 3 key '`s`' can be pressed to skip the command that has been shown.

## Command file

The only argument for the `ice` program is the name of the file that contains the command lines to be executed. Practically this might be a shell script, although multi-line constructions are not supported.

When a command line in this file is preceded by a '`!`' it will be executed using '`sudo sh -c`' (so with root privileges). For this purpose it is advised to configure password-less `sudo`.

When a line in this file starts with a '`.`', a red dot will be displayed for two seconds to indicate that a special action is required (e.g. showing the results of another program during a demo before you want to continue with the next command line). The rest of the command line can be used as comment.

When a line in this file starts with a '`#`' it is skipped (comment). Also empty lines are skipped.

### An example of a command file:

`# run program that consumes 100% CPU`  
`  usecpu&`  
  
`. show 100% CPU utilization with atop`  
  
`# set CPU consumption limit of 10%`  
`! systemctl set-property user.slice  CPUQuota=10%`  
  
`. show 10% CPU utilization with atop`   
  
`# kill CPU consumer and revert cgroups setting`  
`  killall usecpu`  
  
`! systemctl revert user.slice`  

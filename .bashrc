#
#	$Source: /afs/.pitt.edu/common/uss/skel/RCS/bash_profile,v $
#
#	$Author: jjc $
#
#	This is the user's login script for the GNU Bourne Again Shell (bash)
#
#	$Id: bash_profile,v 2.5 1991/10/10 16:05:29 jjc Exp $
#

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#
#		  PLEASE DO NOT EDIT THIS SCRIPT
#		UNLESS YOU KNOW WHAT YOU ARE DOING
#
#	      PLEASE READ THIS SECTION BEFORE EDITING!!
#
# Editing this script before reading this section can disrupt 
# the use of your account.  
#
# 
# The intent of this script is to set values for the prompt and other
# shell variables.  Some of the settings that can be made listed below.
# For a comprehensive list, please consult the man page by typing:
# 
# 	$ man .bash_profile
# 
# Variables and settings that you do not specifically set may be
# assigned default values by the global bash_profile script.
# 
# ** PLEASE CONSULT THE MAN PAGE FOR LIST OF THE VARIABLES THAT CAN BE
# SET AND THEIR DEFAULTS.**  The variables listed in this file are only
# ones that are the more important ones.
# 
# If you need to obtain a new copy of this file, you can issue the
# following command:
#
#
# $ rm -f $HOME/.bash_profile ; 
#   /bin/cp /afs/pitt.edu/common/uss/skel/bash_profile $HOME/.bash_profile
#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#

#################################################################
# INTERACTIVE MESSAGES STATUS
#################################################################
#
# This command controls whether you will accept "talk" or "write"
# requests from other users.  If you don't want other users to
# interrupt you with "talk" or "write" requests, set messages to
# "off". If you want people to be able to interrupt you, set
# messages to "on". If you have messages turned off, another 
# user trying to contact you will be told that you are not 
# accepting messages at this time.
#
# The default is to have messages turned off.

MESSAGES=off

#################################################################
# TERMINAL
#################################################################
#
#
# The Global Login script will try to query your terminal to see what
# type of terminal you are using.  Sometimes this is not sucessful.  
# The "defaultterm" setting below will be used as your terminal setting
# if the Global Login Script cannot determine your terminal type.

DEFAULTTERM=vt100

#################################################################
# PATH
#################################################################
#
# The core of your path is set by the global login script.  The core
# contains all of the directories necessary so that you can run all of
# the software that we support.  There are a few options you can use to
# customize your path.
# 
# The first option is the "pathtype" option.  If the "pathtype" option
# is set to "pitt", your path will be constructed so that software that
# we support, such as the GNU emacs, GNU make, and GNU tar will be
# executed instead of the vendor provided commands.  If you wish to
# execute the vendor supplied commands instead, set the "pathtype"
# option to "vendor".  Do not abbreviate "pitt" or "vendor".

PATHTYPE=pitt

# The second option allows you specify additional directories to be
# included in your path, either before or after the core path.  If you
# want to specify directories to be searched before the core path,
# define these in the "prepath" definition.  If you have directories
# that you wish to have searched after the core path, place those in the
# "postpath" definition.  By default, your ~/bin directory is in the
# prepath.  For security reasons, it is recommended that if you elect
# to include other users' directories in you path, you should include
# them in the postpath.  If you need to include "." in your path
# do not do it here; see the variable 'cwdinpath' below.
 
PREPATH=$HOME/bin
POSTPATH=

# The last option concerns whether the current working directory is in
# your path.  For security and performance reasons, we do not include
# the current working directory in the core path. We recommend that you tell
# the shell specifically when you wish to run a command in the current
# working directory with the ./filename syntax.  If you feel you need to
# have the current working directory in the path, change the next option
# from "no" to "first" or "last".  If you change this option to "first",
# the current working directory will be placed at the beginning of the
# path.  If you change this option to "last", the current working
# directory will be placed at the end of the path.  If you decide that
# you do want the current working directory in your path, we recommend
# that your place it at the end of your path, so you are less likely to
# mistakenly execute the wrong program.

CWDINPATH=no

#################################################################
# UMASK SETUP
#################################################################
#
# The umask does not affect files within AFS. Only if AFS files
# are moved to a non-AFS directory with the file permissions intact is
# the umask is significant.  For information on the umask command, see
# the manpage on "umask".

umask 022

#################################################################
# COMMAND HISTORY
#################################################################
#
#
# The history list is a list of the most recent commands you have
# issued.  This list can be used to recall commands that you have
# previously executed.  For more information see the man page for
# bash
#

export HISTCONTROL=ignoreboth
export HISTSIZE=1000

#################################################################
# FORCE THE USE OF THE "logout" COMMAND INSTEAD OF CONTROL-D
# 	TO LOGOUT
#################################################################
#
# IGNOREEOF controls the action of the shell on receipt of an
# EOF (^D, Control-D) character as the sole input from the login
# terminal. If set, the value is the number of consecutive EOF
# characters type before the shell will exit. If IGNOREEOF is
# set to a null value, the shell assumes a default value of 10.
# If it does not exist, EOF signifies the end of input to the
# shell and the shell exits.
# 
# To turn this option off, comment out the line below
export IGNOREEOF=2

#################################################################
# NOTIFY USER OF COMMAND COMPLETIONS
#################################################################
#
# If the notify variable is set, the shell reports terminated
# background jobs immediately, rather that waiting until the
# next shell prompt.
# 
# To turn this option off, comment out the line below
export notify=

#################################################################
# PROMPT SETTING
#################################################################
#
# When executing interactively, bash displays the primary
# prompt PS1 when it is ready to read a command, and the
# secondary prompt PS2 when it needs more input to complete a
# command.  Bash allows the prompt to be customized by insert-
# ing a number of backslash-escaped special characters that
# are decoded as follows:
# 	\t   the time
# 	\d   the date
# 	\n   CRLF
# 	\s   the name of the shell, the basename of $0
# 	\w
# 	\W   the current working directory
# 	\u   the username of the current user
# 	\h   the hostname
# 	\#   the command number of this command
# 	\!   the history number of this command
# 	\$   if the effective UID is 0, a #, otherwise a $
# 	\nnn character code in octal
# 	\\   a backslash
#
# After the string is decoded, if the variable NO_PROMPT_VARS
# is not set, it is expanded via parameter expansion, command
# substitution, arithmetic expansion, and word splitting.

#export PS1='[\u@\h \W] \$ '
export PS2='more> '

#################################################################
# ENVIRONMENT VARIABLES
#################################################################
#
# These variables are used by various programs.
#
# Default values have been set at this point.
# 
# If you have no reason to change the defaults, do not uncomment
# these setting below.

#################################################################
# ENVIRONMENT VARIABLE: PRINTER
#################################################################
#
# The PRINTER variable is used to set your default printer.  If you
# do not select a printer below, your default printer will be set
# to the system-wide default.  A list of printers available is in
# /etc/printcap
#
# In the commented line below, the printer is set to be the LPS-40 in
# Old Engineering Hall.  If you want to chose a specific printer to be
# your default, uncomment the line below and change "oeh" to be the
# printer you wish to select.

# export PRINTER=oeh

#################################################################
# ENVIRONMENT VARIABLE: DISPLAY
#################################################################
#
# The next line can be used to set your DISPLAY for X-windows clients
#
# export DISPLAY=x.x.pitt.edu:0.0

#################################################################
# ENVIRONMENT VARIABLE: EDITOR
#################################################################
#
# If you wish to have emacs be your default editor, uncomment the
# following two variable definitions.
#
# export VISUAL=/usr/contrib/bin/emacs
# export EDITOR=/usr/contrib/bin/emacs

#################################################################
# ALIASES
#################################################################
#
# Note that aliases in bash are VERY different from aliases
# in C-shell. From a practical point of view, aliases in
# bash have been superceded by shell functions. For more
# information about shell functions, see man bash.



#################################################################
# DO NOT EDIT BELOW THIS LINE!!!!!!!!!
#----------------------------------------------------------------
#  $Id: bash_profile,v 2.5 1991/10/10 16:05:29 jjc Exp $
#################################################################

#################################################################
# EXECUTION OF GLOBAL LOGIN FILE
#################################################################
# 
# The following command will execute the global login script. This
# script will do things such as set your terminal type. 

source /afs/pitt.edu/common/etc/bash_profile.global

#################################################################
#  $Id: bash_profile,v 2.5 1991/10/10 16:05:29 jjc Exp $
#----------------------------------------------------------------
# DO NOT EDIT ABOVE THIS LINE!!!!!!!!!
#################################################################


#################################################################
# SHELL FUNCTIONS & USER COMMANDS
#################################################################
#
# Shell functions can be used to define sophisticated commands
# that execute in the same process as the shell, i.e. no 
# sub-shell is forked.
#
# Define your own private shell functions and other commands here




#################################################################
# USER COMMANDS
#################################################################
# 
# Put any commands you wish to execute upon login below.  Don't
# set variables.


if [ "$HOSTNAME" = "thot.cs.pitt.edu" ]; then
	source /opt/set_specific_profile.sh
else
    case "$HOSTNAME" in
        pc5506-*.cs.pitt.edu)
            export PATH="$PATH:/opt/dmm141/minet"
            ;;
    esac
fi

if [ -e ~/.bash_profile ]; then
    source ~/.bash_profile
fi

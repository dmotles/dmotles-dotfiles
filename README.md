# The master dotfiles for dmotles
This is my current attempt at configuring my system and my VIM to act as IDE, and saving it for posterity's sake.

# Install (Mac OSX)
1. Install homebrew. Make sure shit works
2. Run the following:
    brew install autoconf bash-completion ctags dos2unix git
3. Pull down repo into user's home folder ~
    git clone git@github.com:dmotles/dmotles-dotfiles.git
4. Do submodule shit
    git submodule init && git submodule update
5. Run the install for command-t
    cd vimplugins/command-t/ruby/command-t
    ruby extconf.rb
    make
6. Run vim and run `:call pathogen#helptags()`
7. HOPEFULLY everything works out OK. If not, may $diety have mercy on your soul.

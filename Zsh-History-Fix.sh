# Using `zsh` for my shell on Kali, corrupts my history file every now and again. I drafted this quick script as a quick fix. 

#!/usr/bin/env zsh
mv ~/.zsh_history ~/.zsh_history_bad
strings -eS .zsh_history_bad > .zsh_history
fc -R .zsh_history
rm ~/.zsh_history_bad

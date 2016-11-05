# Path to your oh-my-zsh installation.
  export ZSH=/home/rperier/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="fishy"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git command-not-found systemd)

# User configuration

  export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

project() {
	local -a projectdir contribdir destdir
	projectdir=$HOME/Dev/projets
	contribdir=$HOME/Dev/contribs
	destdir=''

	if [ $# -ne 1 ]; then
		echo "Usage: $(basename $0) <project_name>"
		return 1
	fi

	if [ -d "$projectdir/$1" ]; then
		destdir=$projectdir/$1
	elif [  -d "$contribdir/$1" ]; then
		destdir=$contribdir/$1
	else
		echo "$1 does not exist"
		echo -n "create it [y/n]? "
		read y
		if [ "$y" = "y" ]; then
			echo -n "project or contrib [p/c] ?"
			read t
			if [ "$t" = "p" ]; then
				destdir=$projectdir/$1
			elif [ "$t" = "c" ]; then
				destdir=$contribdir/$1
			else
				"unknown type"
				return 1
			fi
			mkdir $destdir
			echo -n "description: "
			read desc
			echo "project_summary=\"$desc\"\nunset project_summary" > $destdir/.profile
		else
			return 1
		fi
	fi

	cd $destdir

	if [ ! -e "$destdir/.profile" ]; then
		echo "Warning: .profile file not found for entity $1"
	else
		source .profile
	fi
	return 0
}

#compdef project
_project() {
	local -a projects
	projects=()

	for p in $(echo $HOME/Dev/projets/*); do
		projects+="$(basename $p):$(grep '^project_summary' $p/.profile | sed 's/.*="\(.*\)"/\1/g') (project)"
	done
	for p in $(echo $HOME/Dev/contribs/*); do
		projects+="$(basename $p):$(grep '^project_summary' $p/.profile | sed 's/.*="\(.*\)"/\1/g') (contrib)"
	done
	_describe 'projects' projects
	return 0
}

compdef _project project

# Autocompletion for lavabo
autoload -U +X bashcompinit && bashcompinit
eval "$(register-python-argcomplete lavabo)"


export PATH="$HOME/Dev/bin:$HOME/Dev/lavabo:$PATH"


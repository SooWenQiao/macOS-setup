#!/bin/bash
set -euo pipefail

# check command existence
is_cmd () {
    command -v "$1" &> /dev/null 2>&1
}

config_terminal() {
	echo "PROMPT='%F{029}%T:%f %B%F{039}%n%f%b %U%F{119}%2d%u %B%?%b >>%f '" >> ~/.zshrc
	if [ ! -d ~/Desktop/screenshots ]; then 
		mkdir -p ~/Desktop/screenshots
	fi
	sudo defaults write com.apple.screencapture location ~/Desktop/screenshots
	sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHosttInfo HostName
	sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "爱笑的女孩\n运气不会太差🍀"
	sudo defaults write com.apple.Terminal "Basic" -dict-add TabStopWidth -int 2
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
	source ~/.zshrc
}

# ensure the script is being run as root
# if [ "$(id -u)" -ne 0 ]; then
#	echo "This script must be run as root. Use sudo to run it. "
#	exit 1
# fi

is_git() {
	if ! is_cmd git; then 
		echo "Installing git..."
		sudo xcode-select --switch /Library/Developer/CommandLineTools/
	else
		echo "Git installed."
	fi
}

set_git() {
	is_git
	echo "Setting up git now..."
	git --version
	local email="soowenqiao@gmail.com"
	local ssh_key_file="$HOME/.ssh/id_ed25519"
	git config --global user.name "sooqq"
	git config --global user.email "soowenqiao@gmail.com"
	
	ssh-keygen -t ed25519 -C "$email" -f "$ssh_key_file" -N ""
	eval "$(ssh-agent -s)"
	ssh-add "$ssh_key_file"
	pbcopy < "${ssh_key_file}.pub"
	local ssh_config="$HOME/.ssh/config"
	[[ ! -f $ssh_config ]] && touch "$ssh_config"
	echo "Host github.com\n HostName github.com\n User git\n IdentityFile $ssh_key_file\n" >> "$ssh_config"
	chmod 600 "$ssh_config"
	# "Git is missing. Check Xcode CLTs. "
}

is_brew() {
	if ! is_cmd brew; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo >> ~/.zprofile
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
		echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
		echo 'export HOMEBREW_CASK_OPTS="--appdir=/Applications"' >> ~/.zshrc
		source ~/.zshrc
	else
		echo "Homebrew installed. Checking for updates..."
		brew update
	fi
}

set_brew() {
	is_brew
	local base_packages=(
		mas gh pkg-config tree github-keygen ssh-copy-id java openjdk jenv llvm node nvm jenkins mongodb-compass mysql postgresql
		go python pyenv pyenv-virtualenv julia rustup-init tygo swift kubectl freetds R
	)
	local casks=(brave-browser google-chrome opera whatsapp wechat slack zoom visual-studio-code docker rstudio mactex)
	echo "Installing base packages and GUI apps...\n"
	brew install "${base_packages[@]}"
	brew install --cask "${casks[@]}"
	brew cleanup
}

set_neon() {
	if ! is_cmd neonctl; then
		echo "Installing Neon CLI..."
		brew install neonctl
		echo 'export PATH="$HOME/.neon/bin:$PATH"' >> ~/.zshrc
		source ~/.zshrc
	else
		echo "Neon installed. Version: $(neonctl --version)\n"
	fi
}

set_psql() {
    if is_cmd psql; then
        printf "Setting up PostgreSQL...\n"
        brew services start postgresql
        psql postgres -c "CREATE ROLE dev WITH LOGIN PASSWORD 'sqq';" || true
        psql postgres -c "ALTER ROLE dev CREATEDB;" || true
        printf "PostgreSQL is ready. Connect using: psql -U dev -h localhost -d postgres\n"
    else
        printf "PostgreSQL installation failed or missing. Check Homebrew.\n" >&2
    fi
}

set_path_and_symlinks() {
	echo "Setting language environments...\n"
	echo "Setting language path..."
	echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
	echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
	echo 'export PATH="/usr/local/bin/R:$PATH"' >> ~/.zshrc
	echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc
	echo 'export PATH="/opt/homebrew/opt/node/bin:$PATH"' >> ~/.zshrc
	echo 'export PATH="/opt/homebrew/opt/mysql/bin:$PATH"' >> ~/.zshrc
	echo 'export PATH="/opt/homebrew/opt/julia/bin:$PATH"' >> ~/.zshrc
	source ~/.zshrc
	if is_cmd java; then
		sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
		echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc
		echo 'export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"' >> ~/.zshrc
		echo 'export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"' >> ~/.zshrc
		source ~/.zshrc
		echo "Java path added. Version: $(java --version)"
	fi
	if is_cmd pyenv; then
		echo 'PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
		echo 'PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
		echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
		source ~/.zshrc
		echo "pyenv path added."
	fi
	if is_cmd mysql; then
		brew services start mysql
		echo "MySQL installed. Version: $(mysql --version)"
	fi
	if is_cmd R; then
		echo 'export LC_ALL=en_US.UTF-8' >> ~/.zshrc
		echo 'export LANG=en_US.UTF-8' >> ~/.zshrc
		source ~/.zshrc
		echo "R installed. Version: $(R --version)"
	fi
	if is_cmd rstudio; then
		echo "RStudio installed. Version: $(rstudio --version)"
		open -a RStudio
	fi
}

#	packages=(
#		jupyter numpy pandas scipy simpy sympy
#		matplotlib seaborn plotly ggplot pyLDAvis
#		scikit-learn textblob nltk gensim
#		xgboost lightgbm catboost
#		tensorflow keras torch torchvision
#		transformers spacy
#		opencv-python
#		gym stable-baselines3
#		hdfs pyspark dask ray
#		requests beautifulsoup4 scrapy selenium lxml flask streamlit
#	)

main_setup() {
	config_terminal
	set_brew
	set_git
	set_neon
	set_psql
	set_path_and_symlinks
	chmod +x ./hello.sh
	./hello.sh
}

main_setup

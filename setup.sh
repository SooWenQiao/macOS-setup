#!/bin/bash

# appleid login & wifi connection
# airport command is deprecated, can use .mobileconfig, 
# but it can only be installed from Apple GUI, can't from terminal anymore
# check current network connection
networksetup -getairportnetwork en0
# generate UUID for wifi connection profile nusstu.mobileconfig
echo "UUID=$(uuidgen)" >> ~/.zshrc
source ~/.zshrc

# list all possible nearby wifi connection: system_profiler SPAirPortDataType
# list all files: ls -a /usr/bin

# terminal configuration
echo '# prompt configuration' >> ~/.zshrc
echo "PROMPT='%F{029}%T:%f %B%F{039}%n%f%b %U%F{119}%2d%u %B%?%b >>%f '" >> ~/.zshrc
echo "Prompt configuration added and applied."
source ~/.zshrc

mkdir -p ~/Desktop/screenshots
sudo defaults write com.apple.screencapture location ~/Desktop/screenshots
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "爱笑的女孩\n运气不会太差🍀"

sudo defaults write com.apple.Terminal "Basic" -dict-add TabStopWidth -int 2
killall Terminal

# check command existence
command_exists() {
        command -v "$1" &> /dev/null 2>&1
}

# ensure the script is being run as root
# if [ "$(id -u)" -ne 0 ]; then
#	echo "This script must be run as root. Use sudo to run it. "
#	exit 1
# fi

# brew installation
if ! command_exists brew; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	echo "Homebrew installed. Checking for updates..."
	brew update
fi

# git installation
if ! command_exists git; then
	echo "Installing git..."
	sudo xcode-select --switch /Library/Developer/CommandLineTools/
	git --version
else
	echo "Git installed. Version: "
	git --version
fi

# clang installation
if ! command_exists clang; then
	echo "Installing Clang..."
	brew install llvm
	echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc
	source ~/.zshrc
else
	echo "Clang installed. Version: "
	clang --version
fi

# java installation
if ! command_exists java; then
	echo "Installing Java... "
	brew install java
	sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
	echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> ~/.zshrc
	echo 'export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"' >> ~/.zshrc
	export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
	source ~/.zshrc
	java --version
else
	echo "Java installed. Version: "
	java --version
fi

# python and its packages installation
if ! command_exists python3; then
	echo "Installing Python..."
	brew install python
	brew install jupyterlab python-matplotlib python-requests
else
	echo "Python3 installed. Version:"
	python3 --version
fi

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

# julia installation
if ! command_exists julia; then
	echo "Installing Julia... "
	brew install julia
	echo "Julia installed. "
else
	echo "Julia installed. "
	julia --version
fi

# javascript installation
if ! command_exists node; then
	echo "Installing Node.js..."
	brew install node
else
	echo "Node.js installed. Version:"
	node --version
fi

# MySQL installation
if ! command_exists mysql; then
        echo "Installing MySQL..."
        brew install mysql
        brew services start mysql
else
        echo "MySQL installed. Version: "
        mysql --version
fi

# VS Code installation
if ! command_exists code; then
	echo "Installing Visual Studio Code..."
	brew install --cask visual-studio-code
else
	echo "Visual Studio Code installed. Version: "
	code --version
fi

# Docker installation
if ! command_exists docker; then
	echo "Installing Docker... "
	brew install --cask docker
	open /Applications/Docker.app
	echo "Docker installed. "
else
	echo "Docker installed. Version: "
	docker --version
fi

# R and RStudio installation
if ! command_exists R; then
	echo "Installing R... "
	brew install R
	echo 'export PATH="/usr/local/bin/R:$PATH"' >> ~/.zshrc
	source ~/.zshrc
	echo "R installed."
	Rscript -e 'install.packages(c("tidyverse", "data.table", "ggplot2", "dplyr", "shiny", "caret", "randomForest", "e1071"), repos="http://cran.rstudio.com/")'
else
	echo "R installed. Version:"
	R --version
fi

if ! command_exists rstudio; then
        echo "Installing RStudio..."
        brew install --cask rstudio
        echo "RStudio installed."
	open -a RStudio
else
        echo "RStudio installed. Version:"
        rstudio --version
fi

# Testing compiled programming languages
chmod +x ~/hello.sh
./hello.sh

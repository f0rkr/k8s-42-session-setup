#!/bin/bash
echo "#################### THIS SETUP SAVED ON GOINFRE IN ORDER TO SAVE SPACE ###################"
# Setup variables 
BREW_HOME=$HOME/.brew
BREW_GOINFRE=$HOME/goinfre/.brew
DOCKER_HOME=$DOCKER_HOME
DOCKER_GOINFRE=$HOME/goinfre/.docker
MINIKUBE_HOME=$HOME/.minikube
MINIKUBE_GOINFRE=$HOME/goinfre/.minikube
if [ ! -d $BREW_GOINFRE ]
then
	echo "⭐️ $(tput setaf 1)------- setup HomeBrew -------$(tput sgr 0) ⭐️"
	rm -rf BREW_HOME && git clone --depth=1 https://github.com/Homebrew/brew $BREW_GOINFRE && echo 'export PATH=$HOME/goinfre/.brew/bin:$PATH' >> $HOME/.zshrc && source $HOME/.zshrc && brew update
fi
[ ! -d $DOCKER_GOINFRE ] && echo "⭐️ $(tput setaf 1)------- Setup docker --------$(tput sgr 0) ⭐️" && brew install docker docker-machine
echo  "💨 $(tput setaf 5)------- Running Docker VM --------$(tput sgr 0) 💨"
echo -n "😄  " ;docker-machine create --driver virtualbox default
echo -n "🐳  " ;docker-machine start
docker-machine env default
eval "$(docker-machine env default)"
if [ ! -d $DOCKER_GOINFRE ]
then
	mv $DOCKER_HOME $DOCKER_GOINFRE
	ln -s $DOCKER_GOINFRE $DOCKER_HOME
fi

[ ! -d $MINIKUBE_GOINFRE ] && echo "⭐️ $(tput setaf 1)------- Setup k8s + minikube ---------$(tput sgr 0) ⭐️" && brew install minikube
echo "💨 $(tput setaf 5)------- Running Minikube VM --------$(tput sgr 0) 💨"
minikube start
if [ ! -d $MINIKUBE_GOINFRE ]
then
	mv $MINIKUBE_HOME $HOME/goinfre/
	ln -s $MINIKUBE_GOINFRE $MINIKUBE_HOME
fi

echo "[+] DONE "

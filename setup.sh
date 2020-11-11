#!/bin/bash
echo "#################### THIS SETUP SAVED ON GOINFRE IN ORDER TO SAVE SPACE ###################"
# Setup variables 
BREW_HOME=$HOME/.brew
BREW_GOINFRE=$HOME/goinfre/.brew
DOCKER_HOME=$HOME/.docker
DOCKER_GOINFRE=$HOME/goinfre/.docker
MINIKUBE_HOME=$HOME/.minikube
MINIKUBE_GOINFRE=$HOME/goinfre/.minikube
#removing cache
rm -rf $DOCKER_HOME
rm -rf $MINIKUBE_HOME
rm -rf $DOCKER_GOINFRE
rm -rf $MINIKUBE_GOINFRE
rm -rf $BREW_GOINFRE
rm -rf $BREW_HOME
killall -9 VBoxHeadless; VBoxManage unregistervm --delete "default" >/dev/null 2>&1
killall -9 VBoxHeadless; VBoxManage unregistervm --delete "minikube"  >/dev/null 2>&1
echo > $HOME/.k8s
if [ ! -d $BREW_GOINFRE ]
then
	echo "⭐️ $(tput setaf 1)------- setup HomeBrew -------$(tput sgr 0) ⭐️"
	rm -rf $BREW_HOME && git clone --depth=1 https://github.com/Homebrew/brew $BREW_GOINFRE && echo 'export PATH=$HOME/goinfre/.brew/bin:$PATH' >> $HOME/.k8s && source $HOME/.k8s && brew update
fi
[ ! -d $DOCKER_GOINFRE ] && echo "⭐️ $(tput setaf 1)------- Setup docker --------$(tput sgr 0) ⭐️" && brew install docker docker-machine
echo  "💨 $(tput setaf 5)------- Running Docker VM --------$(tput sgr 0) 💨"
echo -n "😄  " ;docker-machine create --driver virtualbox default
echo -n "🐳  " ;docker-machine start
docker-machine env default
eval "$(docker-machine env default)"
mv $DOCKER_HOME $HOME/goinfre/ 
ln -s $DOCKER_GOINFRE $DOCKER_HOME

[ ! -d $MINIKUBE_GOINFRE ] && echo "⭐️ $(tput setaf 1)------- Setup k8s + minikube ---------$(tput sgr 0) ⭐️" && brew install minikube 
echo "💨 $(tput setaf 5)------- Running Minikube VM --------$(tput sgr 0) 💨"
minikube delete
minikube start
mv $MINIKUBE_HOME $HOME/goinfre
ln -s $MINIKUBE_GOINFRE $MINIKUBE_HOME

#setup .zshrc file
if [ -d $DOCKER_GOINFRE ]
then
	echo "docker-machine start default 1>/dev/null 2>/dev/null" >> $HOME/.k8s
	echo "docker-machine env default 1>/dev/null" >> $HOME/.k8s
	echo "eval \$(docker-machine env default)" >> $HOME/.k8s
	source $HOME/.k8s
fi
echo "source \$HOME/.k8s" >> $HOME/.zshrc
echo "[+] DONE "

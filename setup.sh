echo "#################### THIS SETUP SAVED ON GOINFRE IN ORDER TO SAVE SPACE ###################"
if [ ! -d $HOME/goinfre/.brew ]
then
	echo "------- setup HomeBrew -------"
	rm -rf $HOME/.brew && git clone --depth=1 https://github.com/Homebrew/brew $HOME/goinfre/.brew && echo 'export PATH=$HOME/goinfre/.brew/bin:$PATH' >> $HOME/.zshrc && source $HOME/.zshrc && brew update
fi
echo "------- Setup and start docker --------"
[ ! -d $HOME/goinfre/.docker ] && brew install docker docker-machine
docker-machine create --driver virtualbox default
docker-machine start
docker-machine env default
eval "$(docker-machine env default)"
if [ ! -d $HOME/goinfre/.docker ]
then
	mv $HOME/.docker $HOME/goinfre/.docker
	ln -s $HOME/goinfre/.docker $HOME/.docker
fi
echo "------- Setup and start k8s + minikube ---------"
[ ! -d $HOME/goinfre/.minikube ] && brew install minikube
minikube start
if [ ! -d $HOME/goinfre/.minikube ]
then
	mv $HOME/.minikube $HOME/goinfre/
	ln -s $HOME/goinfre/.minikube $HOME/.minikube
fi

echo "[+] DONE "

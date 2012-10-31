# this script requires vagrant
cd ./onboard
git clone git://github.com/felixge/node-cross-compiler.git
cd ./node-cross-compiler
vagrant up
vagrant ssh -c "cd cross-compiler && ./setup-vm.sh && make ardrone2"
cp ./node/build/node ..
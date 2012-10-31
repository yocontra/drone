# this script requires vagrant
# build node for arm7l on vm
cd ./onboard
git clone git://github.com/felixge/node-cross-compiler.git
cd ./node-cross-compiler
vagrant up
vagrant ssh -c "cd cross-compiler && ./setup-vm.sh && make ardrone2 && tar czf ./build/node.tar.gz ./build/bin/node "
cp ./build/node.tar.gz ../

# npm bin file needs edit for path
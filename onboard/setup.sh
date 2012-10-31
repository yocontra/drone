# copy deps into build foldr
# tar them in the vm
# copy to drone

cd ./onboard/node-cross-compiler
mkdir -p ./build/node_modules
cp -R ../../node_modules/ar-drone ./build/node_modules

vagrant up
vagrant ssh -c "cd cross-compiler/build && tar czf ./deps.tar.gz ./node_modules/ar-drone"

{ echo "mkdir -p /data/video/labs/ && exit"; sleep 1; } | telnet 192.168.1.1

ftp -u ftp://anonymous:anonymous@192.168.1.1/labs/deps.tar.gz ./build/deps.tar.gz
ftp -u ftp://anonymous:anonymous@192.168.1.1/labs/repl.js ../repl.js
{ echo "cd /data/video/labs/ && tar xvzf deps.tar.gz && rm -rf deps.tar.gz && exit"; sleep 1; } | telnet 192.168.1.1

echo "ar-drone has been installed on the drone!"
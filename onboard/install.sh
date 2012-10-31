# copy built node to drone over ftp
# telnet in and set shit up
cd ./onboard
ftp -u ftp://anonymous:anonymous@192.168.1.1/node.tar.gz ./node.tar.gz

{ echo "cd /data/video && tar xvzf node.tar.gz && mv build/bin/node /bin && rm -rf node.tar.gz && rm -rf build && exit"; sleep 1; } | telnet 192.168.1.1

echo "Node has been installed on the drone!"
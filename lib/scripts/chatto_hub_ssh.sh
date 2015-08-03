#!/bin/sh
cd tmp
if [ ! -d repos ]
then 
    mkdir repos 
fi
cd repos
git clone "$1:$2" $3
cd $3
git remote add new-origin "$1:$4"
git push new-origin master

cd ..
rm -rf $3

#!/bin/sh
cd tmp
if [ ! -d repos ]
then 
    mkdir repos 
fi
cd repos
git clone $1 $2
cd $2
git remote add new-origin $3
git push new-origin master

cd ..
rm -rf $2

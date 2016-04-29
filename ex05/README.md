# Subsymbolic methods in AI, exercise 005

## Install D compilers and D package manager on OSX

    brew install ldc dmd dub

## Install D compilers and D package manager on Debian

    sudo wget http://netcologne.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
    sudo apt-get update && sudo apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring && sudo apt-get update
    sudo apt-get install ldc dub

## Install dependencies for pygame on Debian

    sudo apt-get install libsdl-dev

## Install Python dependencies

    sudo pip3 install cython
    sudo pip3 install -r requirements.txt
    garden install graph

## Build dependencies for D

    dub build

## Build modules for Python

    cd source
    python3 setup.py build

## Install D compilers and D package manager

    brew install ldc dmd dub
    sudo pip3 install pyd

## Build dependencies for D

    dub build

## Build modules for Python

    cd source/py
    python3 setup.py build

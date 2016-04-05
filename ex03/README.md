# Subsymbolic methods in AI, exercise 03

## Install D compilers and D package manager

    brew install ldc dmd dub

## Install Python dependencies

    sudo pip3 install -r requirements.txt
    kivy install graph

## Build dependencies for D

    dub build

## Build modules for Python

    cd source/py
    python3 setup.py build

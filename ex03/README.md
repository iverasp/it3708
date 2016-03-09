## Install compilers and package manager

brew install ldc dmd dub
sudo pip3 install pyd

## Build dependencies

dub build

## Build modules for Python

cd source/py
python3 setup.py build

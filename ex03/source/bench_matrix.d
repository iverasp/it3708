import ann.matrix;

import std.stdio;
import std.conv;

void main() {
    foreach(i; 0 .. 1000) {
        Matrix a = new Matrix(100,50);
        a.randomize();
        Matrix b = new Matrix(50,100);
        b.randomize();
        auto c = a * b;
    }

}

import std.stdio;
import std.string;
import std.conv;


import ann.ann;
import ann.matrix;

public void main() {
  ANN ann = new ANN();
  ann.learn(1);
  /*
  Matrix m1 = new Matrix(2,2);
  m1.randomize();
  Matrix m2 = new Matrix(2,2);
  m2.randomize();
  writeln(to!string(m1));
  writeln(to!string(m2));
  auto m3 = m1 - m2;
  writeln(to!string(m3));
  auto m4 = m1 * m2;
  writeln(to!string(m4));
  auto m5 = 2 * m4;
  writeln(to!string(m5));
  */

}

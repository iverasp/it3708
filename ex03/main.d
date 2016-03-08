import std.stdio;
import std.string;
import std.conv;

import NN;

public void main() {
  NN nn = new NN();
  writeln(to!string(nn.synapsis0));
  writeln("lol");
  writeln(to!string(nn.synapsis1));
  nn.runNN(1);
}

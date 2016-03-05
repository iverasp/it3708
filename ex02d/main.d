import std.stdio;
import std.string;
import std.conv;

import LolzIndividual;
import SurprisingIndividual;

public void main() {
  writeln("hello world");
  //LolzIndividual ind = new LolzIndividual(20, 20);
  SurprisingIndividual ind = new SurprisingIndividual(20, 5, 2., true);
  ind.generate_genotype();
  char[] lol;
  int[] tmp = ind.get_genotype();
  for (int i = 0; i < tmp.length; i++) {
    writeln(tmp[i]);
    lol[i] = to!char(tmp[i]);
  }
  writeln(lol);
}

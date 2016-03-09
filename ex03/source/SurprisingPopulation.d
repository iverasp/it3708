import std.stdio;
import std.conv;
import std.string;
import std.random;

import population;
import SurprisingIndividual;
import individual;

public class SurprisingPopulation : Population {

  int symbol_set;
  bool global;

  this(int childs, int gl, int symb, bool glob) {
    super(childs, gl);
    symbol_set = symb;
    global = glob;
    writeln("global " ~ to!string(global));
  }

  override public Individual[] generate_children() {
    Individual[] result = new Individual[](number_of_children);
    foreach(i; 0 .. number_of_children) {
      auto newborn = new SurprisingIndividual(genotype_length, symbol_set, global);
      newborn.generate_genotype();
      result[i] = newborn;
    }
    return result;
  }

  override public void reproduce() {
    children = new Individual[](0);
    foreach (i; 0 .. parents.length) {
      auto chance = uniform(0.0f, 1.0f);
      if (chance < 0.01f) { // TODO: crossover rate
        foreach (j; 0 .. 1) { // TODO: children per pair
          int phenlength = to!int(parents[i][0].phenotype.length);
          //writeln("phenlength " ~ to!string(phenlength));
          int crossoverpoint = uniform(1, phenlength + 1);
          auto newborn = new SurprisingIndividual(genotype_length, symbol_set, global);
          newborn.genotype = parents[i][0].genotype[0..crossoverpoint].dup ~ parents[i][1].genotype[crossoverpoint..parents[i][1].genotype.length].dup;
          children.length = children.length + 1;
          //writeln("newborn " ~ to!string(newborn.genotype));
          //writeln("children length " ~ to!string(children.length));
          children[children.length - 1] = newborn;
        }
      } else {
        foreach (j; 0 .. 1) { // TODO: children per pair
          int parent_index = j % 2;
          //writeln("parent index " ~ to!string(parent_index));
          auto newborn = new SurprisingIndividual(genotype_length, symbol_set, global);
          //writeln("gen " ~ to!string(genotype_length));
          //newborn.generate_genotype();
          //newborn.generate_phenotype();
          if (chance < 0.99f) { // TODO: mutation rate
            //writeln("index " ~ to!string(j) ~ ":" ~ to!string(parent_index));
            //parents[j][parent_index].generate_genotype();
            //parents[j][parent_index].generate_phenotype();
            auto genotype = parents[i][parent_index].phenotype.dup;
            //writeln(to!string(genotype.length));
            auto index = uniform(0, genotype.length);
            genotype[index] = uniform(0, symbol_set);
            newborn.genotype = genotype;
            //writeln("newborn " ~ to!string(newborn.genotype));

          } else {
            newborn.genotype = parents[i][parent_index].phenotype.dup;
          }
          children.length = children.length + 1;
          children[children.length - 1] = newborn;
        }
      }
    }
    for (int i = 0; i < adults.length; i++) {
      adults[i].grow();
    }
  }

}

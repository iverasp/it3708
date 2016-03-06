import std.stdio;
import std.string;
import std.conv;

import LolzIndividual;
import SurprisingIndividual;
import Population;

// TODO: change for to foreach(i; 0 .. range) wow such speed
// also use "auto" all over

public void main() {
  writeln("hello world");

  auto population = new Population(100, 21, 1);

  foreach (i; 0 .. 200) {
    writeln("Generation: " ~ to!string(i + 1));
    population.develop();
    writeln("Developed");
    population.evaluate();
    writeln("Evaluated");
    population.adult_selection();
    writeln("Adults selected");
    population.parent_selection();
    writeln("Parents selected");
    population.reproduce();
    writeln("Reproduced");

    double highest_fitness = 0;
    Individual fittest_adult;
    for (int j = 0; j < population.adults.length; j++) {
      if (population.adults[j].fitness > highest_fitness) {
        highest_fitness = population.adults[i].fitness;
        fittest_adult = population.adults[i];
      }
    }
    writeln("Highest fitness: " ~ to!string(highest_fitness));
    writeln("Fittest phenotype: " ~ to!string(fittest_adult.phenotype));
  }
}

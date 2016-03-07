import std.stdio;
import std.string;
import std.conv;

//import LolzIndividual;
import SurprisingIndividual;
//import Population;
import SurprisingPopulation;

// TODO: change for to foreach(i; 0 .. range) wow such speed
// also use "auto" all over

public void main() {

  auto population = new SurprisingPopulation(100, 25, 9, true);

  foreach (i; 0 .. 2000) {
    writeln("Generation: " ~ to!string(i + 1));
    population.develop();
    //writeln("Developed");
    population.evaluate();
    //writeln("Evaluated");
    population.adult_selection();
    //writeln("Adults selected");
    population.parent_selection();
    //writeln("Parents selected");
    population.reproduce();
    //writeln("Reproduced");

    double highest_fitness = 0;
    string fittest_phenotype = "";
    for (int j = 0; j < population.adults.length; j++) {
      if (population.adults[j].fitness > highest_fitness) {
        highest_fitness = population.adults[j].fitness;
        fittest_phenotype = to!string(population.adults[j].phenotype);
      }
    }
    writeln("Highest fitness: " ~ to!string(highest_fitness));
    writeln("Fittest phenotype: " ~ fittest_phenotype);
    if (highest_fitness == 1.0f) break;
  }
}

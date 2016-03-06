import std.container;
import std.random;
import std.algorithm.sorting;
import std.conv;
import std.math;
import std.stdio;

import Individual;

public class Population {

  Individual[] children;
  Individual[] adults;
  Individual[] children_fitness;
  Individual[][] parents;
  double temperature;
  double average_fitness;
  double standard_deviation;
  int genotype_length;
  auto gen = Random();
  int number_of_children;

  this(int childs, int gl, double temperature) {
    number_of_children = childs;
    //children = new Individual[number_of_children];
    genotype_length = gl;
    children = generate_children();
    //writeln("Children " ~ to!string(children.length));

    temperature = temperature;
  }

  private Individual[] generate_children() {
    Individual[] result = new Individual[number_of_children];
    for (int i = 0; i < number_of_children; i++) {
      Individual individual = new Individual(genotype_length);
      individual.generate_genotype();
      //writeln("child " ~ to!string(individual.genotype.length));
      result[i] = individual;
    }
    return result;
  }

  public void develop() {
    for (int i = 0; i < children.length; i++) {
      children[i].generate_phenotype();
    }
  }

  public void evaluate() {
    Individual[] children_fitness = new Individual[number_of_children];
    for (int i = 0; i < children.length; i++) {
      children[i].evaluate_fitness();
      children_fitness[i] = children[i];
    }

    bool myComp(Individual x, Individual y) @safe pure nothrow {
      return x.fitness > y.fitness;
    }

    sort!(myComp)(children);

    /*
    // TODO: optimize this section
    auto h = heapify(children_fitness);
    for (int i = 0; i < children.length; i++) {
      children[i] = h.front;
      h.removeFront;
    }
    */
  }

  public void adult_selection() {
    full_replacement();
  }

  public void parent_selection() {
    tournament_selection();
  }

  private void full_replacement() {
    adults = new Individual[number_of_children];
    for (int i = 0; i < children.length; i++) {
      children[i].mature();
      adults[i] = children[i];
    }
    children = new Individual[number_of_children];
  }

  private void tournament_selection() {
    Individual[][] myParents = new Individual[][](100);

    bool myComp(Individual x, Individual y) @safe pure nothrow {
      return x.fitness > y.fitness;
    }

    int newparents = 0;
    while (newparents < 100) { // TODO: number_of_children / children_per_pair
      //writeln("Parents selection, size " ~ to!string(parents.length));
      auto adult_pool = adults.dup;
      randomShuffle(adult_pool);
      auto tournament_groups = new Individual[][](10, 10);
      auto adult_index = adult_pool.length;
      //writeln("Pool " ~ to!string(adult_index));
      foreach(i; 0 .. 10) { // TODO: population_size / group_size
        foreach(j; 0 .. 10) { // TODO: group_size
          //writeln(to!string(adult_index));
          if (adult_index > -1.0f) {
            tournament_groups[i][j] = adult_pool[adult_index-- - 1];
            //writeln("Adult index " ~ to!string(adult_index));
          }
        }
      }
      for (int i = 0; i < tournament_groups.length; i++) {
        auto chance = uniform(0.0f, 1.0f, gen);
        if (chance < 1 - 0.2) { // TODO: epsilon
          sort!(myComp)(tournament_groups[i]);
        }
        auto pair = new Individual[2];
        pair[0] = tournament_groups[i][tournament_groups[i].length - 1];
        pair[1] = tournament_groups[i][tournament_groups[i].length - 2];
        //writeln("Adding to parents " ~ to!string(parents.length));
        myParents[newparents] = pair;
        //writeln("parent length " ~ to!string(newparents));
        newparents++;

        if (!newparents < 100) break; // TODO: number_of_children / children_per_pair
      }
    }
    parents = myParents;
  }

  public void reproduce() {
    Individual[] children = new Individual[](0);
    for (int i = 0; i < parents.length; i++) {
      auto chance = uniform(0.0f, 1.0f, gen);
      if (chance < 0.01) { // TODO: crossover rate
        for (int j = 0; j < 1; j++) { // TODO: children per pair
          int phenlength = to!int(parents[i][0].phenotype.length);
          int crossoverpoint = uniform(1, phenlength, gen);
          Individual newborn = new Individual(genotype_length);
          newborn.genotype = parents[i][0].genotype[0..crossoverpoint] ~ parents[i][1].genotype[crossoverpoint..parents[i][1].genotype.length];
          children.length = children.length + 1;
          children[children.length - 1] = newborn;
        }
      } else {
        for (int j = 0; j < 1; j++) { // TODO: children per pair
          int parent_index = j % 2;
          Individual newborn = new Individual(genotype_length);
          //writeln("gen " ~ to!string(genotype_length));
          newborn.generate_genotype();
          newborn.generate_phenotype();
          if (chance < 1) {// TODO: mutation rate
            //writeln("index " ~ to!string(j) ~ ":" ~ to!string(parent_index));
            parents[j][parent_index].generate_genotype();
            parents[j][parent_index].generate_phenotype();
            auto genotype = parents[j][parent_index].phenotype.dup;
            //writeln(to!string(genotype.length));
            auto index = uniform(0, genotype.length, gen);
            if (genotype[index] == 0) genotype[index] = 1;
            else genotype[index] = 0;
            newborn.genotype = genotype;
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

  public void generate_information() {
    double total_fitness = 0;
    int number_of_adults = 0;
    double variance_numerator = 0;
    double variance = 0;
    for (int i = 0; i < adults.length; i++) {
      total_fitness += adults[i].fitness;
      number_of_adults++;
    }
    average_fitness = total_fitness / number_of_adults;
    for (int i = 0; i < adults.length; i++) {
      variance_numerator += pow(adults[i].fitness - average_fitness, 2);
    }
    variance = variance_numerator / number_of_adults;
    standard_deviation = sqrt(variance);
  }

}

module ea.population;

import std.container;
import std.random;
import std.algorithm.sorting;
import std.conv;
import std.math;
import std.stdio;

import pyd.pyd;

import ea.individual;

public class Population {

  Individual[] children;
  Individual[] adults;
  Individual[] children_fitness;
  Individual[][] parents;
  double average_fitness;
  double standard_deviation;
  int genotype_length;
  int number_of_children;

  this(int childs, int gl) {
    number_of_children = childs;
    //children = new Individual[number_of_children];
    genotype_length = gl;
    children = generate_children();
    //writeln("Children " ~ to!string(children.length));
  }

  override string toString() {
    return "Children: " ~ to!string(number_of_children) ~ " Genotype length: " ~ to!string(genotype_length);
  }

  public Individual[] getAdults() {
    return adults;
  }

  public Individual[] generate_children() {
    Individual[] result = new Individual[number_of_children];
    for (int i = 0; i < number_of_children; i++) {
      auto individual = new Individual(genotype_length);
      individual.generate_genotype();
      //writeln("child " ~ to!string(individual.genotype.length));
      result[i] = individual;
    }
    return result;
  }

  public void develop() {
    //writeln("childs " ~ to!string(children.length));
    for (int i = 0; i < children.length; i++) {
      //writeln(to!string(i));
      children[i].generate_phenotype();
    }
  }

  public void evaluate() {
    children_fitness = new Individual[number_of_children];
    for (int i = 0; i < children.length; i++) {
      children[i].evaluate_fitness();
      children_fitness[i] = children[i];
    }

    bool myComp(Individual x, Individual y) @safe pure nothrow {
      return x.fitness < y.fitness;
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
    auto myParents = new Individual[][](100); // TODO: number_of_children

    bool myComp(Individual x, Individual y) @safe pure nothrow {
      return x.fitness < y.fitness;
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
      foreach (i; 0 .. tournament_groups.length) {
        auto chance = uniform(0.0f, 1.0f);
        if (chance < 1f - 0.2f) { // TODO: epsilon
          sort!(myComp)(tournament_groups[i]);
          /*
          writeln("sorted?");
          foreach (x; 0 .. 10) {
            write(to!string(tournament_groups[i][x].fitness) ~ ", ");
          }
          writeln();
          */
        }
        auto pair = new Individual[2];
        pair[0] = tournament_groups[i][tournament_groups[i].length - 1];
        pair[1] = tournament_groups[i][tournament_groups[i].length - 2];
        //writeln("Adding to parents " ~ to!string(parents.length));
        myParents[newparents] = pair.dup;
        //writeln("parent length " ~ to!string(newparents));
        newparents++;

        if (!newparents < 100) break; // TODO: number_of_children / children_per_pair
      }
    }
    parents = myParents.dup;
    /*
    foreach (i; 0 .. parents.length) {
      foreach (j; 0 .. parents[i].length)
      writeln(parents[i][j].phenotype);
    }
    */
  }

  public void reproduce() {
    children = new Individual[](0);
    foreach (i; 0 .. parents.length) {
      auto chance = uniform(0.0f, 1.0f);
      if (chance < 0.01f) { // TODO: crossover rate
        foreach (j; 0 .. 1) { // TODO: children per pair
          int phenlength = to!int(parents[i][0].phenotype.length);
          //writeln("phenlength " ~ to!string(phenlength));
          int crossoverpoint = uniform(1, phenlength + 1);
          auto newborn = new Individual(genotype_length);
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
          auto newborn = new Individual(genotype_length);
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
            if (genotype[index] == 0) genotype[index] = 1;
            else genotype[index] = 0;
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

// PyD API

extern(C) void PydMain() {
    module_init();
    wrap_class!(
        Population,
        Init!(int, int),
        Def!(Population.generate_information),
        Def!(Population.reproduce),
        Def!(Population.parent_selection),
        Def!(Population.adult_selection),
        Def!(Population.evaluate),
        Def!(Population.develop),
        Repr!(Population.toString),
        Def!(Population.getAdults)
    )();
    wrap_class!(
      Individual,
      Init!(int),
      Def!(Individual.getFitness),
      Def!(Individual.getPhenotype)
    )();
}

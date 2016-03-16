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
  Individual[] childrenFitness;
  Individual[][] parents;
  double averageFitness;
  double standardDeviation;
  int genotypeLength;
  int numberOfChildren;

  this(int childs, int gl) {
    numberOfChildren = childs;
    //children = new Individual[number_of_children];
    genotypeLength = gl;
    children = generateChildren();
    //writeln("Children " ~ to!string(children.length));
  }

  override string toString() {
    return "Children: " ~ to!string(numberOfChildren) ~ " Genotype length: " ~ to!string(genotypeLength);
  }

  public Individual[] getAdults() {
    return adults;
  }

  public Individual[] generateChildren() {
    Individual[] result = new Individual[numberOfChildren];
    foreach (i; 0 .. number_of_children) {
      auto individual = new Individual(genotypeLength);
      individual.generateGenotype();
      result[i] = individual;
    }
    return result;
  }

  public void develop() {
    //writeln("childs " ~ to!string(children.length));
    foreach(i; 0 .. children.length) {
      //writeln(to!string(i));
      children[i].generatePhenotype();
    }
  }

  public void evaluate() {

    childrenFitness = new Individual[numberOfChildren];
    foreach(i; 0 .. children.length) {
      children[i].evaluateFitness();
      childrenFitness[i] = children[i];
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

  public void adultSelection() {
    fullReplacement();
  }

  public void parentSelection() {
    tournamentSelection();
  }


  private void fullReplacement() {
    adults = new Individual[numberOfChildren];
    foreach(i; 0 .. children.length) {
      children[i].mature();
      adults[i] = children[i];
    }
    children = new Individual[numberOfChildren];
  }

  private void tournamentSelection() {
    auto myParents = new Individual[][](100); // TODO: number_of_children

    bool myComp(Individual x, Individual y) @safe pure nothrow {
      return x.fitness < y.fitness;
    }

    int newparents = 0;
    while (newparents < 100) { // TODO: number_of_children / children_per_pair
      //writeln("Parents selection, size " ~ to!string(parents.length));
      auto adultPool = adults.dup;
      randomShuffle(adultPool);
      auto tournamentGroups = new Individual[][](10, 10);
      auto adultIndex = adultPool.length;
      //writeln("Pool " ~ to!string(adult_index));
      foreach(i; 0 .. 10) { // TODO: population_size / group_size
        foreach(j; 0 .. 10) { // TODO: group_size
          //writeln(to!string(adult_index));
          if (adultIndex > -1.0f) {
            tournamentGroups[i][j] = adultPool[adultIndex-- - 1];
            //writeln("Adult index " ~ to!string(adult_index));
          }
        }
      }
      foreach (i; 0 .. tournamentGroups.length) {
        auto chance = uniform(0.0f, 1.0f);
        if (chance < 1f - 0.2f) { // TODO: epsilon
          sort!(myComp)(tournamentGroups[i]);
          /*
          writeln("sorted?");
          foreach (x; 0 .. 10) {
            write(to!string(tournament_groups[i][x].fitness) ~ ", ");
          }
          writeln();
          */
        }
        auto pair = new Individual[2];
        pair[0] = tournamentGroups[i][tournamentGroups[i].length - 1];
        pair[1] = tournamentGroups[i][tournamentGroups[i].length - 2];
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
          auto newborn = new Individual(genotypeLength);
          newborn.genotype = parents[i][0].genotype[0..crossoverpoint].dup ~ parents[i][1].genotype[crossoverpoint..parents[i][1].genotype.length].dup;
          children.length = children.length + 1;
          //writeln("newborn " ~ to!string(newborn.genotype));
          //writeln("children length " ~ to!string(children.length));
          children[children.length - 1] = newborn;
        }
      } else {
        foreach (j; 0 .. 1) { // TODO: children per pair
          int parentIndex = j % 2;
          //writeln("parent index " ~ to!string(parent_index));
          auto newborn = new Individual(genotypeLength);
          //writeln("gen " ~ to!string(genotype_length));
          //newborn.generate_genotype();
          //newborn.generate_phenotype();
          if (chance < 0.99f) { // TODO: mutation rate
            //writeln("index " ~ to!string(j) ~ ":" ~ to!string(parent_index));
            //parents[j][parent_index].generate_genotype();
            //parents[j][parent_index].generate_phenotype();
            auto genotype = parents[i][parentIndex].phenotype.dup;
            //writeln(to!string(genotype.length));
            auto index = uniform(0, genotype.length);
            if (genotype[index] == 0) genotype[index] = 1;
            else genotype[index] = 0;
            newborn.genotype = genotype;
            //writeln("newborn " ~ to!string(newborn.genotype));

          } else {
            newborn.genotype = parents[i][parentIndex].phenotype.dup;
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

  public void generateInformation() {
    double totalFitness = 0;
    int numberOfAdults = 0;
    double varianceNumerator = 0;
    double variance = 0;
    for (int i = 0; i < adults.length; i++) {
      totalFitness += adults[i].fitness;
      numberOfAdults++;
    }
    averageFitness = totalFitness / numberOfAdults;
    for (int i = 0; i < adults.length; i++) {
      varianceNumerator += pow(adults[i].fitness - averageFitness, 2);
    }
    variance = varianceNumerator / numberOfAdults;
    standardDeviation = sqrt(variance);
  }

}

// PyD API

extern(C) void PydMain() {
    module_init();
    wrap_class!(
        Population,
        Init!(int, int),
        Def!(Population.generateInformation),
        Def!(Population.reproduce),
        Def!(Population.parentSelection),
        Def!(Population.adultSelection),
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

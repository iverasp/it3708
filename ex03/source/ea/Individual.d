module ea.individual;

import std.string;
import std.random;
import std.stdio;
import std.conv;

import pyd.pyd;

public class Individual {

  public bool adult;
  public int age;
  public int[] genotype;
  public int[] phenotype;
  public double fitness;
  public double fitnessRange;
  public int genotypeLength;

  this(int gl) {
    adult = false;
    age = 0;
    fitness = 0.;
    fitnessRange = 0.;
    genotypeLength = gl;
    //writeln("len " ~ to!string(gl));
    genotype = new int[](genotypeLength);
    phenotype = new int[](genotypeLength);
  }

  public int[] getPhenotype() {
    return phenotype;
  }

  public double getFitness() {
    return fitness;
  }

  public void mature() {
    adult = true;
  }

  public void grow() {
    age++;
  }

  public int[] getGenotype() {
    return genotype;
  }

  public void generateGenotype() {
    for (int i = 0; i < genotypeLength; i++) {
      genotype[i] = uniform(0, 2);
    }
  }

  public void generatePhenotype() {
    for (int i = 0; i < genotypeLength; i++) {
      phenotype[i] = genotype[i];
    }
    //writeln("phe " ~ to!string(phenotype.length));
  }

  public void evaluateFitness() {
    fitness = 0.;
    for (int i = 0; i < genotypeLength; i++) {
      fitness += genotype[i];
    }
    fitness = fitness / genotypeLength;
  }
}

/*

// PyD API

extern(C) void PydMain() {
  module_init();
  wrap_class!(
    Individual,
    Init!(int),
    Def!(Individual.getPhenotype),
    Def!(Individual.getFitness)
  )();
}
*/

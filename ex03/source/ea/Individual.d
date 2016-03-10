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
  public double fitness_range;
  public int genotype_length;

  this(int gl) {
    adult = false;
    age = 0;
    fitness = 0.;
    fitness_range = 0.;
    genotype_length = gl;
    //writeln("len " ~ to!string(gl));
    genotype = new int[](genotype_length);
    phenotype = new int[](genotype_length);
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

  public int[] get_genotype() {
    return genotype;
  }

  public void generate_genotype() {
    for (int i = 0; i < genotype_length; i++) {
      genotype[i] = uniform(0, 2);
    }
  }

  public void generate_phenotype() {
    for (int i = 0; i < genotype_length; i++) {
      phenotype[i] = genotype[i];
    }
    //writeln("phe " ~ to!string(phenotype.length));
  }

  public void evaluate_fitness() {
    fitness = 0.;
    for (int i = 0; i < genotype_length; i++) {
      fitness += genotype[i];
    }
    fitness = fitness / genotype_length;
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

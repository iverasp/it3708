module ea.individual;

import std.string;
import std.random;
import std.stdio;
import std.conv;
import std.algorithm;

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
    phenotype = genotype.dup;
    //writeln("phe " ~ to!string(phenotype.length));
  }

  public void evaluateFitness() {
    fitness = to!double(genotype.sum) / to!double(genotype.length);

  }
}

module ea.individual;

import std.string;
import std.random;
import std.stdio;
import std.conv;
import std.algorithm;
import pyd.pyd;

public class Individual {

    /// These are generic variables
    private bool adult;
    private int age;
    private float[] genotype;
    private float[] phenotype;
    private double fitness;
    private double fitnessRange;
    private int genotypeLength;

    /// These are problem specific variables
    private int devouredFood;
    private int devouredPoison;

    /// #TODO 1) fix indenting and fitness calculation
    /// 2) Test wether private variables break anything

  this(int gl) {
    adult = false;
    age = 0;
    fitness = 0.;
    fitnessRange = 0.;
    genotypeLength = gl;
    //writeln("len " ~ to!string(gl));
    genotype = new float[](genotypeLength);
    phenotype = new float[](genotypeLength);
  }

  public float[] getPhenotype() {
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

  public float[] getGenotype() {
    return genotype;
  }

  public void generateGenotype() {
    for (int i = 0; i < genotypeLength; i++) {
      genotype[i] = uniform01();
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

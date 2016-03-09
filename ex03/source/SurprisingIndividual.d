import std.random;
import std.conv;
import std.stdio;
import std.string;

import individual;

public class SurprisingIndividual : Individual {

  private int symbol_set;
  private bool global;

  this(int gl, int symbl, bool glob) {
    super(gl);
    symbol_set = symbl;
    global = glob;
  }

  override public void generate_genotype() {
    foreach(i; 0 .. genotype_length) {
      genotype[i] = uniform(0, symbol_set + 1);
    }
  }

  override public void generate_phenotype() {
    for (int i = 0; i < genotype_length; i++) {
      phenotype[i] = genotype[i];
    }
  }

  override public void evaluate_fitness() {
    /*
    if (global) fitness = evaluate_fitness_global();
    else fitness = evaluate_fitness_local();
    */
    fitness = evaluate_fitness_global();
  }

  private double evaluate_fitness_global() {
    int[string] items;
    double error = 0;
    int count = 0;
    for (int i = 0; i < genotype_length; i++) {
      for (int j = i + 1; j < genotype_length; j++) {
        string sequence = to!string(phenotype[i]) ~ "-" ~ to!string(phenotype[j]) ~ ":" ~ to!string(j - i);
        if (sequence in items) error++;
        else {
          items[sequence] = count;
          count++;
        }
      }
    }
    double max_error = (to!double(genotype_length) * to!double((genotype_length - 1))) / 2.0f;
    //writeln("max " ~ to!string(max_error));
    //writeln("err " ~ to!string(error));
    return (max_error - error) / max_error;
  }

  private double evaluate_fitness_local() {
    int[string] items;
    double error = 0;
    int count = 0;
    for (int i = 0; i < genotype_length - 1; i++) {
      string sequence = to!string(phenotype[i]) ~ "-" ~ to!string(phenotype[i+1]);
      if (sequence in items) error++;
      else {
        items[sequence] = count;
        count++;
      }
    }
    double max_error = (genotype_length * (genotype_length - 1)) / 2;
    //writeln("max " ~ to!string(max_error));
    //writeln("err " ~ to!string(error));
    return (max_error - error) / max_error;
  }

}

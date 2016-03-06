import std.random;
import std.conv;

import Individual;

public class SurprisingIndividual : Individual {

  private int symbol_set;
  private double surprising_fitness;
  private bool global;

  this(int genotype_length, int symbol_set, double surprising_fitness, bool global) {
    super(genotype_length);
    symbol_set = symbol_set;
    surprising_fitness = surprising_fitness;
    global = global;
  }

  override public void generate_genotype() {
    for (int i = 0; i < genotype_length; i++) {
      genotype[i] = uniform(0, symbol_set + 1, gen);
    }
  }

  override public void generate_phenotype() {
    for (int i = 0; i < genotype_length; i++) {
      phenotype[i] = genotype[i];
    }
  }

  override public void evaluate_fitness() {
    if (global) fitness = evaluate_fitness_global();
    else fitness = evaluate_fitness_local();
  }

  private double evaluate_fitness_global() {
    string[string] items;
    double error = 0;
    int count = 0;
    for (int i = 0; i < genotype_length; i++) {
      for (int j = i + 1; j < genotype_length; j++) {
        string sequence = to!string(phenotype[i]) ~ "-" ~ to!string(phenotype[j]) ~ ":" ~ to!string(j - 1);
        if (sequence in items) error++;
        else {
          items[to!string(count)] = sequence;
          count++;
        }
      }
    }
    double max_error = (genotype_length * (genotype_length - 1)) / 2;
    return (max_error - error) / max_error;
  }

  private double evaluate_fitness_local() {
    string[string] items;
    double error = 0;
    int count = 0;
    for (int i = 0; i < genotype_length - 1; i++) {
      string sequence = to!string(phenotype[i]) ~ "-" ~ to!string(phenotype[i+1]);
      if (sequence in items) error++;
      else {
        items[to!string(count)] = sequence;
        count++;
      }
    }
    double max_error = (genotype_length * (genotype_length - 1)) / 2;
    return (max_error - error) / max_error;
  }

}

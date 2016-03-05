import std.string;
import std.random;

public class Individual {

  public bool adult;
  public int age;
  public int[] genotype;
  public int[] phenotype;
  public double fitness;
  public double fitness_range;
  public int genotype_length;
  public auto gen = Random();

  this() {}

  this(int genotype_length) {
    adult = false;
    age = 0;
    fitness = 0.;
    fitness_range = 0.;
    genotype_length = genotype_length;
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
      genotype[i] = uniform(0, 2, gen);
    }
  }

  public void generate_phenotype() {
    for (int i = 0; i < genotype_length; i++) {
      phenotype[i] = genotype[i];
    }
  }

  public void evaluate_fitness() {
    fitness = 0.;
    for (int i = 0; i < genotype_length; i++) {
      fitness += genotype[i];
    }
  }
}

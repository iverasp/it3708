import Individual;

public class LolzIndividual : Individual {

  private int z_value;

  this(int genotype_length, int z_value) {
    super(genotype_length);
    this.z_value = z_value;
  }

  override public void evaluate_fitness() {
    fitness = 1.;
    int counter = 1;
    if (phenotype[0] == 0) {
      while (counter < phenotype.length && phenotype[counter] == 0) {
        fitness++;
        counter++;
      }
      if (z_value < fitness) fitness = z_value;
    } else if (phenotype[0] == 1) {
      while (counter < phenotype.length && phenotype[counter] == 0) {
        fitness++;
        counter++;
      }

    }
  }
}

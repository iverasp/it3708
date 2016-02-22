import java.util.ArrayList;
import java.util.Collections;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 22/02/16.
 */
public class LOLZ implements Problem {

    private int z;
    private int genotypeSize;

    public LOLZ(int z, int genotypeSize) {
        this.z = z;
        this.genotypeSize = genotypeSize;
    }

    @Override
    public int mutateGenomeComponent(int component) {
        return component == 1 ? 0 : 1;
    }

    @Override
    public double fitness(String phenotype) {
        return 0;
    }

    @Override
    public ArrayList<Individual> createInitialPopulation(int size) {
        ArrayList<Individual> individuals = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            String genotype = Integer.toString(ThreadLocalRandom.current().nextInt(0, 2));
            individuals.add(new Individual(genotype));
        }
        return individuals;
    }

    @Override
    public String genotypeToPhenotype(String genotype) {
        return genotype;
    }

    @Override
    public ArrayList<Individual> adultSelection(ArrayList<Individual> population) {
        ArrayList<Individual> result = new ArrayList<>();
        return result;
    }

    @Override
    public Individual parentSelection(ArrayList<Individual> population, int k, double epsilon, double... args) {
        ArrayList<Individual> sampleGroup = (ArrayList<Individual>) population.clone();
        ArrayList<Individual> group = new ArrayList<>();
        for (int i = 0; i < k; i++) {
            Collections.shuffle(sampleGroup);
            group.add(sampleGroup.get(0));
        }
        double chance = ThreadLocalRandom.current().nextDouble();
        if (chance < epsilon)
            return group.get(ThreadLocalRandom.current().nextInt(0, group.size()));
        return null;
    }

    private Individual setAdult(Individual individual) {
        individual.setMature(true);
        return individual;
    }

    @Override
    public Individual crossover(Individual parent1, Individual parent2) {
        double chance = ThreadLocalRandom.current().nextDouble();
        int cutoff = (int) (Integer.valueOf(parent1.getGenotype()) * chance);
        String genotype = parent1.getGenotype().substring(cutoff, parent1.getGenotype().length()) +
                parent2.getGenotype().substring(0, cutoff);
        return new Individual(genotype);
    }

    @Override
    public ArrayList<Individual> mutate(ArrayList<Individual> population, double rate) {
        for (Individual individual : population) {
            double chance = ThreadLocalRandom.current().nextDouble();
            if (chance <= rate) {
                int randomIndex = ThreadLocalRandom.current().nextInt(0, Integer.valueOf(individual.getGenotype()));
                //individual.genotype[rand_index] = component_modifier(individual.genotype[rand_index])
            }
        }
        return population;
    }
}

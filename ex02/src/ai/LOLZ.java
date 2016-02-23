package ai;

import java.util.ArrayList;
import java.util.Collections;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 22/02/16.
 */
public class LOLZ extends AbstractProblem implements Problem {

    private int z;
    private int genotypeSize;

    public LOLZ(int z, int genotypeSize) {
        this.z = z;
        this.genotypeSize = genotypeSize;
    }

    @Override
    public char mutateGenomeComponent(char component) {
        return mutateGenomeComponentSimple(component);
    }

    @Override
    public double fitness(String phenotype) {
        System.out.println("Phenotype: " + phenotype);
        int counter = 0;
        char count = phenotype.charAt(0);

        for (int i = 0; i < phenotype.length(); i++) {
            if (phenotype.charAt(i) != count) break;
            counter += 1;
        }
        if (count == '0') counter = Integer.toString(Math.min(this.z, counter)).charAt(0);
        double lol = this.genotypeSize - counter;

        return 1 - lol / (double) this.genotypeSize;
    }

    @Override
    public ArrayList<Individual> adultSelection(ArrayList<Individual> population) {
        return fullReplacement(population);
    }

    @Override
    public Individual parentSelection(ArrayList<Individual> population, double k, double epsilon, double... args) {
        return tournamentSelection(population, k, epsilon);
    }

    @Override
    public Individual crossover(Individual parent1, Individual parent2) {
        return onePointCrossover(parent1, parent2);
    }

    @Override
    public ArrayList<Individual> mutate(ArrayList<Individual> population, double rate) {
        return mutatePerGenome(population, rate);
    }

    public Individual tournamentSelection(ArrayList<Individual> population, double k, double epsilon, double... args) {
        //ArrayList<Individual> sampleGroup = (ArrayList<Individual>) population.clone();
        ArrayList<Individual> group = new ArrayList<>();
        for (int i = 0; i < k; i++) {
            Collections.shuffle(population);
            group.add(population.get(0));
        }
        double chance = ThreadLocalRandom.current().nextDouble();
        if (chance < epsilon)
            return group.get(ThreadLocalRandom.current().nextInt(0, group.size()));
        double fittest = 0;
        Individual fittestIndividual = population.get(0);
        for (Individual individual : group) {
            if (individual.getPhenotype().isEmpty()) individual.setPhenotype(genotypeToPhenotype(individual.getGenotype()));
            individual.setFitness(fitness(individual.getPhenotype()));
            if (individual.getFitness() > fittest) {
                fittest = individual.getFitness();
                fittestIndividual = individual;
            }
        }
        System.out.println("fittest: " + fittest);
        return fittestIndividual;
    }
}

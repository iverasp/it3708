package ai;

import java.util.ArrayList;
import java.util.Collections;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 23/02/16.
 */
public abstract class AbstractProblem {

    public ArrayList<Individual> createInitialPopulation(int size, int genotypeSize) {
        //System.out.println("Initial genotypes");
        ArrayList<Individual> individuals = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            String genotype = "";
            for (int j = 0; j < genotypeSize; j++) {
                genotype += Integer.toString(ThreadLocalRandom.current().nextInt(0, 2));
            }
            //System.out.println(genotype);
            individuals.add(new Individual(genotype));
        }
        return individuals;
    }

    public String genotypeToPhenotype(String genotype) {
        return genotype;
    }

    public ArrayList<Individual> fullReplacement(ArrayList<Individual> population) {
        ArrayList<Individual> result = new ArrayList<>();
        for (Individual individual : population) {
            if (!individual.isMature()) {
                setAdult(individual);
                result.add(individual);
            }
        }
        return result;
    }

    public Individual setAdult(Individual individual) {
        individual.setMature(true);
        return individual;
    }

    public ArrayList<Individual> mutatePerGenome(ArrayList<Individual> population, double rate) {
        for (Individual individual : population) {
            double chance = ThreadLocalRandom.current().nextDouble();
            if (chance <= rate) {
                int randomIndex = ThreadLocalRandom.current().nextInt(0, individual.getGenotype().length());
                char mutation = mutateGenomeComponentSimple(individual.getGenotype().charAt(randomIndex));

                StringBuilder mutationString = new StringBuilder(individual.getGenotype());
                mutationString.setCharAt(randomIndex, mutation);
                individual.setGenotype(mutationString.toString());
            }
        }
        return population;
    }

    public char mutateGenomeComponentSimple(char component) {
        return component == '1' ? '0' : '1';
    }

    public Individual onePointCrossover(Individual parent1, Individual parent2) {
        double chance = ThreadLocalRandom.current().nextDouble();
        int cutoff = (int) (parent1.getGenotype().length() * chance);
        String genotype = parent1.getGenotype().substring(0, cutoff) +
                parent2.getGenotype().substring(cutoff, parent2.getGenotype().length());
        return new Individual(genotype);
    }


}

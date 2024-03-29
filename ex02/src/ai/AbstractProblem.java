package ai;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 23/02/16.
 */
public abstract class AbstractProblem {

    private String adultMec;
    private String parentMec;
    private int numberOfAdults;

    public List<Individual> createInitialPopulation(int size, int genotypeSize) {
        //System.out.println("Initial genotypes");
        List<Individual> individuals = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            String genotype = "";
            for (int j = 0; j < genotypeSize; j++) {
                char randomChar = (char) ThreadLocalRandom.current().nextInt(65, 67);
                genotype += randomChar;
            }
            //System.out.println(genotype);
            individuals.add(new Individual(genotype));
        }
        return individuals;
    }

    public String genotypeToPhenotype(String genotype) {
        return genotype;
    }

    public List<Individual> fullReplacement(List<Individual> population) {
        ArrayList<Individual> result = new ArrayList<>();
        for (Individual individual : population) {
            if (!individual.isMature()) {
                setAdult(individual);
                result.add(individual);
            }
        }
        return result;
    }

    public List<Individual> overProduction(List<Individual> population, int numberOfAdults) {

        ArrayList<Individual> result = new ArrayList<>();
        for (Individual individual : population) {
            if (!individual.isMature()) {
                setAdult(individual);
                result.add(individual);
            }
        }
        Collections.sort(result);
        Collections.reverse(result);

        if (result.size() <= numberOfAdults) return result;
        return result.subList(0, numberOfAdults);
    }

    public List<Individual> generationalMixing(List<Individual> population) {
        List<Individual> result = new ArrayList<>();
        for (Individual individual : population) {
            if (!individual.isMature()) setAdult(individual);
            result.add(individual);
        }

        Collections.sort(result);
        Collections.reverse(result);
        if (result.size() <= numberOfAdults) return result;
        return result.subList(0, numberOfAdults);
    }

    public Individual setAdult(Individual individual) {
        individual.setMature(true);
        return individual;
    }

    public List<Individual> mutatePerGenome(List<Individual> population, double rate) {
        for (Individual individual : population) {
            double chance = ThreadLocalRandom.current().nextDouble();
            if (chance <= rate) {
                individual.setPhenotype(genotypeToPhenotype(individual.getGenotype()));
                int randomIndex = ThreadLocalRandom.current().nextInt(0, individual.getPhenotype().length());
                char mutation = mutateGenomeComponentSimple(individual.getPhenotype().charAt(randomIndex));

                StringBuilder mutationString = new StringBuilder(individual.getPhenotype());
                mutationString.setCharAt(randomIndex, mutation);
                individual.setPhenotype(mutationString.toString());
            }
        }
        return population;
    }

    public List<Individual> mutatePerGenomeComponent(List<Individual> population, double rate) {
        for (Individual individual : population) {
            for (int i = 0; i < individual.getGenotype().length(); i++) {
                double chance = ThreadLocalRandom.current().nextDouble();
                if (chance <= rate) {
                    char mutation = mutateGenomeComponentSimple(individual.getGenotype().charAt(i));
                    StringBuilder mutationString = new StringBuilder(individual.getGenotype());
                    mutationString.setCharAt(i, mutation);
                    individual.setGenotype(mutationString.toString());
                }
            }
        }
        return population;
    }

    public char mutateGenomeComponentSimple(char component) {
        return component == 'B' ? 'A' : 'B';
    }

    public Individual onePointCrossover(Individual parent1, Individual parent2) {
        double chance = ThreadLocalRandom.current().nextDouble();
        int cutoff = (int) (parent1.getGenotype().length() * chance);
        String genotype = parent1.getGenotype().substring(0, cutoff) +
                parent2.getGenotype().substring(cutoff, parent2.getGenotype().length());
        return new Individual(genotype);
    }

    public Individual tournamentSelection(List<Individual> population, double k, double epsilon, double... args) {
        List<Individual> sampleGroup = population.subList(0, population.size());
        ArrayList<Individual> group = new ArrayList<>();
        for (int i = 0; i < k; i++) {
            Collections.shuffle(sampleGroup);
            group.add(sampleGroup.get(0));
        }
        double chance = ThreadLocalRandom.current().nextDouble();
        if (chance < epsilon)
            return group.get(ThreadLocalRandom.current().nextInt(0, group.size()));
        Individual fittestIndividual = population.get(0);
        double fittest = fittestIndividual.getFitness();
        for (Individual individual : group) {
            if (individual.getPhenotype().isEmpty())
                individual.setPhenotype(genotypeToPhenotype(individual.getGenotype()));
            individual.setFitness(fitness(individual.getPhenotype()));
            if (individual.getFitness() > fittest) {

                fittest = individual.getFitness();
                fittestIndividual = individual;
            }
        }
        //System.out.println("fittest: " + fittest);
        return fittestIndividual;
    }

    public abstract double fitness(String phenotype);

    public Individual fitnessProportionateSelection(List<Individual> population) {
        double totaltFitness = 0;
        for (Individual individual : population) {
            individual.setPhenotype(genotypeToPhenotype(individual.getGenotype()));
            individual.setFitness(fitness(individual.getPhenotype()));
            totaltFitness += individual.getFitness();
        }
        double chance = ThreadLocalRandom.current().nextDouble(0, totaltFitness);
        double tmp = 0;
        for (Individual individual : population) {
            tmp += individual.getFitness();
            if (tmp > chance) return individual;

        }
        return population.get(0);
    }

    public Individual boltzmanSelection(List<Individual> population, double temperature) {
        double totalFitness = 0;
        double totalFitnessScaled = 0;
        double expTotalFitness = 0;
        List<Double> temperatureScaled = new ArrayList<>();
        for (Individual individual : population) {
            individual.setPhenotype(genotypeToPhenotype(individual.getGenotype()));
            individual.setFitness(fitness(individual.getPhenotype()));
            totalFitness += individual.getFitness();
            expTotalFitness += Math.exp(individual.getFitness()) / temperature;
        }
        expTotalFitness /= (double) population.size();
        for (Individual individual : population) {
            double lol = Math.exp(individual.getFitness() / temperature) / expTotalFitness;
            temperatureScaled.add(lol);
            totalFitnessScaled += lol;
        }
        double chance = ThreadLocalRandom.current().nextDouble(0, totalFitnessScaled + 1);
        double risk = 0;
        for (int i = 0; i < population.size(); i++) {
            risk += temperatureScaled.get(i);
            if (risk > chance) return population.get(i);
        }
        return population.get(0);
    }

    public Individual sigmaScalingSelection(List<Individual> population, double temperature) {
        double totalFitness = 0;
        List<Double> fitnesses = new ArrayList<>();
        for (Individual individual : population) {
            individual.setPhenotype(genotypeToPhenotype(individual.getGenotype()));
            individual.setFitness(fitness(individual.getPhenotype()));
            totalFitness += individual.getFitness();
            fitnesses.add(individual.getFitness());
        }
        double average = totalFitness / (double) population.size();
        double std = computeStandardDeviation(fitnesses);
        double totaltScaledFitness = 0;
        List<Double> sigmaScaled = new ArrayList<>();
        for (Double fitness : fitnesses) {
            double scaledFitness = 1 + ((fitness - average) / 2 * std);
            sigmaScaled.add(scaledFitness);
            totaltScaledFitness += scaledFitness;
        }
        double chance = ThreadLocalRandom.current().nextDouble();
        double risk = 0;
        for (int i = 0; i < population.size(); i++) {
            risk += sigmaScaled.get(0);
            if (risk > chance) return population.get(i);
        }
        return population.get(0);
    }

    public void setAdultMechanism(String mechanism) {
        this.adultMec = mechanism;
    }

    public void setParentMechanism(String mechanism) {
        this.parentMec = mechanism;
    }

    public String getAdultMechanism() { return this.adultMec; }

    public String getParentMechanism() { return this.parentMec; }

    private double computeStandardDeviation(List<Double> values) {
        double mean = 0;
        double tmp = 0;
        for (Double value : values) {
            mean += value;
        }
        mean /= (double) values.size();
        for (Double value : values) {
            tmp += Math.pow((value - mean), 2);
        }
        return tmp / (double) values.size();
    }

    public Individual parentSelection(List<Individual> population, double k, double epsilon, double... args) {
        switch (getParentMechanism()) {
            case "fitness_proportionate":
                return fitnessProportionateSelection(population);
            case "tournament":
                return tournamentSelection(population, k, epsilon);
            case "sigma":
                return sigmaScalingSelection(population, 1);
            case "boltzman":
                return boltzmanSelection(population, 1);
            default:
                return tournamentSelection(population, k, epsilon);
        }
    }

    public List<Individual> adultSelection(List<Individual> population) {
        switch (getAdultMechanism()) {
            case "full_replacement":
                return fullReplacement(population);
            case "over_production":
                return overProduction(population, numberOfAdults);
            case "generational_mixing":
                return generationalMixing(population);
            default:
                return fullReplacement(population);
        }
    }
}


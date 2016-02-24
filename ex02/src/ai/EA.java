package ai;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ThreadLocalRandom;
import core.Listener;
import core.Observable;

/**
 * Created by iver on 15/02/16.
 */
public class EA implements Observable {

    private Problem problem;
    private int populationSize;
    private int numberOfAdults;
    private int generations;
    private double epsilon;
    private double crossoverRate;
    private double mutationRate;
    private double adultToChildRatio;
    private double k;
    private double threshold;
    private ArrayList<Double> averages;
    private ArrayList<Double> maximums;
    private ArrayList<Double> standardDeviations;
    private int genotypeSize;
    private int total = 0;
    private String generationMaxPhenotype;

    public EA(
            Problem problem,
            int populationSize,
            int generations,
            double epsilon,
            double crossoverRate,
            double mutationRate,
            double adultToChildRatio,
            double k,
            double threshold,
            int genotypeSize
    ) {
        this.problem = problem;
        this.populationSize = populationSize;
        this.numberOfAdults = (int) (populationSize * adultToChildRatio);
        System.out.println("Number of adults: " + numberOfAdults);
        this.generations = generations;
        this.epsilon = epsilon;
        this.crossoverRate = crossoverRate;
        this.mutationRate = mutationRate;
        this.adultToChildRatio = adultToChildRatio;
        this.k = k;
        this.threshold = threshold;
        this.averages = new ArrayList<>();
        this.maximums = new ArrayList<>();
        this.standardDeviations = new ArrayList<>();
        this.genotypeSize = genotypeSize;
    }

    private boolean runIteration(List<Individual> population, int run) {
        total = 0;
        double generationMaxFitness = -1;
        generationMaxPhenotype = "";
        List<Double> fitnesses = new ArrayList<>();
        boolean completed = false;

        for (Individual individual : population) {
            if (individual.getPhenotype().isEmpty())
                individual.setPhenotype(problem.genotypeToPhenotype(individual.getGenotype()));
            individual.setFitness(problem.fitness(individual.getPhenotype()));
            if (individual.getFitness() == this.threshold) {
                completed = true;
            }
            total += individual.getFitness();
            fitnesses.add(individual.getFitness());
            if (individual.getFitness() > generationMaxFitness) {
                generationMaxFitness = individual.getFitness();
                generationMaxPhenotype = individual.getPhenotype();
            }

            double average = (double) total / (double) population.size();
            averages.add(average);
            maximums.add(generationMaxFitness);
            standardDeviations.add(computeStandardDeviation(fitnesses));

            notifyListener();

            if (completed) return true;

            System.out.println("it: " + run + " fit: " + individual.getFitness() + " phe: " + individual.getPhenotype());

            population = problem.adultSelection(population);

            /*
            List<Individual> children = generateChildren(population);
            System.out.println("generated children");
            children = problem.mutate(children, this.mutationRate);
            population.addAll(children);
            */

            population = generateChildren(population);
            System.out.println("pop size " + population.size());
        }
        return false;
    }

    public void solveProblem() {
        System.out.println("Solving problem...");
        List<Individual> population = problem.createInitialPopulation(populationSize - numberOfAdults, genotypeSize);
        System.out.println("Population size when starting: " + population.size());

        for (int i = 0; i < generations; i++) {
            if (runIteration(population, i)) {
                printStats(i);
                return;
            }
        }
    }

    private void printStats(int run) {
        System.out.println("Generation: " + (run + 1) + " / " + generations);
        System.out.println("Best fitness: " + maximums.get(run));
        System.out.println("Average fitness: " + averages.get(run));
        System.out.println("Standard deviation of fitness: " + standardDeviations.get(run));
        System.out.println("Found phenotype: " + generationMaxPhenotype);
    }

    private List<Individual> generateChildren(List<Individual> population) {
        int openSlots = populationSize - population.size();
        int temperature = Math.max(1, generations - averages.size());
        List<Individual> parents1 = new ArrayList<>();
        List<Individual> parents2 = new ArrayList<>();
        System.out.println("slots " + openSlots);
        for (int j = 0; j < openSlots; j++) {
            parents1.add(problem.parentSelection(population, this.k, this.epsilon, temperature));
            parents2.add(problem.parentSelection(population, this.k, this.epsilon, temperature));
        }
        System.out.println("while");
        List<Individual> children = new ArrayList<>();
        while (children.size() < openSlots) {
            Individual parent1 = parents1.get(parents1.size() - 1);
            Individual parent2 = parents2.get(parents2.size() - 1);
            parents1.remove(parent1);
            parents2.remove(parent2);
            double chance = ThreadLocalRandom.current().nextDouble();
            if (chance < this.crossoverRate)
                children.add(problem.crossover(parent1, parent2));
            else {
                Individual child1 = new Individual(parent1.getGenotype());
                Individual child2 = new Individual(parent2.getGenotype());
                children.add(child1);
                if (openSlots > children.size()) children.add(child2);
            }
        }
        children = problem.mutate(children, this.mutationRate);
        population.addAll(children);
        return population;
    }

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

    // code to maintain listeners
    private List<Listener> listeners = new CopyOnWriteArrayList<>();
    public void add(Listener listener) {listeners.add(listener);}
    public void remove(Listener listener) {listeners.remove(listener);}

    // a sample field
    private int field;
    public int getField() {return field;}
    public void setField(int value) {
        field = value;
        fire("field");
    }

    private void notifyListener() {
        fire("STD");
        fire("AVG");
        fire("MAX");
    }

    public double getLastestStd() {
        return standardDeviations.get(standardDeviations.size() - 1);
    }

    public double getLastestMax() {
        return maximums.get(maximums.size() - 1);
    }

    public double getLastestAvg() {
        return averages.get(averages.size() - 1);
    }

    // notification code
    private void fire(String attribute) {
        for (Listener listener:listeners) {
            listener.fieldChanged(this, attribute);
        }
    }

}

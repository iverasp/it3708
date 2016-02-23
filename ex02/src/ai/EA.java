package ai;

import java.util.ArrayList;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by iver on 15/02/16.
 */
public class EA {

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

    public void solveProblem() {
        System.out.println("Solving problem...");
        ArrayList<Individual> population = problem.createInitialPopulation(populationSize - numberOfAdults, genotypeSize);
        System.out.println("Population size when starting: " + population.size());

        boolean analyzeAfterLoop = true;
        mainloop:
        for (int i = 0; i < generations; i++) {
            int total = 0;
            double generationMaxFitness = -1;
            String generationMaxPhenotype = "";
            ArrayList<Double> fitnesses = new ArrayList<>();
            boolean completed = false;

            for (Individual individual : population) {
                if (individual.getPhenotype().isEmpty())
                    individual.setPhenotype(problem.genotypeToPhenotype(individual.getGenotype()));
                //if (individual.getFitness() != 0)
                    individual.setFitness(problem.fitness(individual.getPhenotype()));
                if (individual.getFitness() == this.threshold) {
                    System.out.println("should be completed now");
                    completed = true;
                    analyzeAfterLoop = false;
                }
                total += individual.getFitness();
                fitnesses.add(individual.getFitness());
                if (individual.getFitness() > generationMaxFitness) {
                    generationMaxFitness = individual.getFitness();
                    generationMaxPhenotype = individual.getPhenotype();
                }

                double average = total / population.size();
                averages.add(average);
                maximums.add(generationMaxFitness);
                standardDeviations.add(computeStandardDeviation(fitnesses));

                if (completed) break mainloop;

                population = problem.adultSelection(population);

                int openSlots = populationSize - population.size();
                int temperature = Math.max(1, generations - averages.size());
                ArrayList<Individual> parents1 = new ArrayList<>();
                ArrayList<Individual> parents2 = new ArrayList<>();
                for (int j = 0; j < openSlots; j++) {
                    parents1.add(problem.parentSelection(population, this.k, this.epsilon, temperature));
                    parents2.add(problem.parentSelection(population, this.k, this.epsilon, temperature));
                }

                ArrayList<Individual> children = new ArrayList<>();
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
            }

            if (analyzeAfterLoop) {
                total = 0;
                generationMaxFitness = -1;
                generationMaxPhenotype = "";
                fitnesses = new ArrayList<>();
                completed = false;

                for (Individual individual : population) {
                    if (individual.getPhenotype().isEmpty())
                        individual.setPhenotype(problem.genotypeToPhenotype(individual.getGenotype()));
                    //if (individual.getFitness() == 0)
                        individual.setFitness(problem.fitness(individual.getPhenotype()));
                    if (individual.getFitness() > threshold || individual.getFitness() == 1.0) {
                        completed = true;
                        analyzeAfterLoop = false;
                        System.out.println("Fittest individual: " + individual.getFitness());
                        break mainloop;
                    }
                    total += individual.getFitness();
                    fitnesses.add(individual.getFitness());
                    if (individual.getFitness() > generationMaxFitness) {
                        generationMaxFitness = individual.getFitness();
                        generationMaxPhenotype = individual.getPhenotype();
                    }
                }

                double average = total / population.size();
                averages.add(average);
                maximums.add(generationMaxFitness);
                standardDeviations.add(computeStandardDeviation(fitnesses));
            }

            System.out.println("Generation: " + i + " / " + generations);
            System.out.println("Best fitness: " + maximums.get(maximums.size() - 1));
            System.out.println("Average fitness: " + averages.get(averages.size() - 1));
            System.out.println("Standard deviation of fitness: " + standardDeviations.get(standardDeviations.size() - 1));
        }
        System.out.println("Generation: " + generations + " / " + generations);
        System.out.println("Best fitness: " + maximums.get(maximums.size() - 1));
        System.out.println("Average fitness: " + averages.get(averages.size() - 1));
        System.out.println("Standard deviation of fitness: " + standardDeviations.get(standardDeviations.size() - 1));
    }

    private double computeStandardDeviation(ArrayList<Double> values) {
        double mean = 0;
        double tmp = 0;
        for (Double value : values) {
            mean += value;
        }
        mean /= values.size();
        for (Double value : values) {
            tmp += Math.sqrt(value - mean);
        }
        return Math.sqrt(tmp/values.size());
    }
}

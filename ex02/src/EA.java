
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
    private int epsilon;
    private int crossoverRate;
    private int mutationRate;
    private int adultToChildRatio;
    private int k;
    private int threshold;
    private ArrayList<Double> averages;
    private ArrayList<Double> maximums;
    private ArrayList<Double> standardDeviations;

    public EA(Problem problem, int populationSize, int generations, int epsilon, int crossoverRate, int mutationRate, int adultToChildRatio, int k, int threshold, ArrayList<Double> averages, ArrayList<Double> maximums) {
        this.problem = problem;
        this.populationSize = populationSize;
        this.numberOfAdults = populationSize * adultToChildRatio;
        this.generations = generations;
        this.epsilon = epsilon;
        this.crossoverRate = crossoverRate;
        this.mutationRate = mutationRate;
        this.adultToChildRatio = adultToChildRatio;
        this.k = k;
        this.threshold = threshold;
        this.averages = averages;
        this.maximums = maximums;
        this.standardDeviations = new ArrayList<>();
    }

    public void solveProblem() {
        ArrayList<Individual> population = problem.createInitialPopulation(populationSize - numberOfAdults);

        for (int i = 0; i < generations; i++) {
            int total = 0;
            double generationMaxFitness = -1;
            String generationMaxPhenotype = "";
            ArrayList<Double> fitnesses = new ArrayList<>();
            boolean completed = false;
            boolean analyzeAfterLoop = true;

            for (Individual individual : population) {
                if (!individual.getPhenotype().equals("0"))
                    individual.setPhenotype(problem.genotypeToPhenotype(individual.getGenotype()));
                if (individual.getFitness() != 0)
                    individual.setFitness(problem.fitness(individual.getPhenotype()));
                if (individual.getFitness() > this.threshold || individual.getFitness() == 0.0) {
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

                if (completed) break;

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
                    if (individual.getFitness() == 0)
                        individual.setFitness(problem.fitness(individual.getPhenotype()));
                    if (individual.getFitness() > threshold || individual.getFitness() == 1.0) {
                        completed = true;
                        analyzeAfterLoop = false;
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
        }
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

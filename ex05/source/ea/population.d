module ea.population;

import ea.ea_config;
import ea.individual;
import tsp.tsp;
import pyd.pyd;
import std.algorithm.sorting;
import std.container;
import std.conv;
import std.math;
import std.random;
import std.stdio;

class Population {

    EaConfig config;
    Individual[] children;
    Individual[] adults;
    Individual[] childrenFitness;
    Individual[][] parents;
    float totalFitness;
    float averageFitness;
    float standardDeviation;
    int[] cities;
    int numberOfCities;
    TSP tsp;

    this(EaConfig config, TSP tsp) {
        this.config = config;
        this.tsp = tsp;
        cities = new int[](tsp.numberOfCities);
        foreach(i; 0 .. tsp.numberOfCities) {
            cities[i] = i;
        }
        children = generateChildren();
    }

    override string toString() {
        return ("Population: " ~ to!string(config.getPopulationSize)
                ~ " Genotype length: " ~ to!string(config.getGenotypeLength));
    }

    @property Individual[] getChildren() { return children; }

    @property Individual[] getAdults() { return adults; }

    @property float getAverageFitness() { return averageFitness; }

    @property float getStandardDeviation() { return standardDeviation; }

    Individual[] generateChildren() {
        Individual[] result = new Individual[config.getNumberOfChildren];
        foreach (i; 0 .. config.getNumberOfChildren) {
            auto individual = new Individual(config, tsp);
            int[] randomGenotype = cities.dup;
            randomShuffle(randomGenotype[]);
            individual.setGenotype(randomGenotype);
            result[i] = individual;
        }
        return result;
    }

    void develop() {
        foreach (i; 0 .. children.length) {
            children[i].generatePhenotype();
        }
    }

    void findObjectiveFunctionValues() {
        foreach(child; children) {
            child.calcValues();
        }

        Individual[] sortedChildren = children.dup;

    }

    void evaluate() {
        childrenFitness = new Individual[config.getNumberOfChildren];
        foreach (child; children) {
            child.evaluateFitness();
        }
        childrenFitness = children.dup;

        bool myComp(Individual x, Individual y) @safe pure nothrow {
            return x.fitness > y.fitness;
        }
        sort!(myComp)(childrenFitness);
    }

    void adultSelection() {
        switch(config.getAdultSelection) {
            case("f"):
                fullReplacement();
                break;
            case("o"):
                overProduction();
                break;
            case("g"):
                generationMixing();
                break;
            default:
                break;
        }
    }

    void fullReplacement() {
        adults = new Individual[config.getPopulationSize];
        foreach (i; 0 .. children.length) {
            adults[i] = children[i];
        }
        children = new Individual[config.getNumberOfChildren];
    }

    void overProduction() {
        adults = new Individual[config.getPopulationSize];
        foreach (i; 0 .. config.getPopulationSize) {
            adults[i] = childrenFitness[i];
        }
        children = new Individual[config.getNumberOfChildren];
    }

    void generationMixing() {
        auto mixedFitness = children.dup;
        if (adults) {
            mixedFitness ~= adults.dup;
        }
        adults = new Individual[config.getPopulationSize];
        bool myComp(Individual x, Individual y) @safe pure nothrow {
            return x.fitness > y.fitness;
        }
        sort!(myComp)(mixedFitness);
        foreach (i; 0 .. config.getPopulationSize) {
            adults[i] = mixedFitness[i];
        }
        children = new Individual[config.getNumberOfChildren];
    }

    void parentSelection() {
        generateInformation();
        switch(config.getParentSelection) {
            case("t"):
                tournamentSelection();
                break;
            default:
                break;
        }
    }

    void tournamentSelection() {
        auto numberOfParents = (config.getNumberOfChildren
                                / config.getChildrenPerPair);
        auto myParents = new Individual[][](numberOfParents);
        bool myComp(Individual x, Individual y) @safe pure nothrow {
            return x.fitness < y.fitness;
        }
        auto newParents = 0;
        while (newParents < numberOfParents) {
            auto adultPool = adults.dup;
            randomShuffle(adultPool);
            auto groupSize = (config.getPopulationSize
                                / config.getTournamentGroupSize);
            auto tournamentGroups = new Individual[][](groupSize, groupSize);
            auto adultIndex = adultPool.length;
            foreach(i; 0 .. groupSize) {
                foreach(j; 0 .. groupSize) {
                    if (adultIndex > -1.0f) {
                        tournamentGroups[i][j] = adultPool[--adultIndex - 1];
                    }
                }
            }
            foreach (i; 0 .. tournamentGroups.length) {
                auto chance = uniform(0.0f, 1.0f);
                if (chance < 1. - config.getTournamentEpsilon) {
                    sort!(myComp)(tournamentGroups[i]);
                }
                auto pair = new Individual[2];
                pair[0] = tournamentGroups[i][tournamentGroups[i].length - 1];
                pair[1] = tournamentGroups[i][tournamentGroups[i].length - 2];
                myParents[newParents] = pair.dup;
                ++newParents;
            }
        parents = myParents.dup;
        }
    }

    void reproduce() {
        children = new Individual[](0);
        foreach (i; 0 .. parents.length) {
            auto chance = uniform(0.0f, 1.0f);
            if (chance < config.getCrossoverRate) {
                foreach (j; 0 .. config.getChildrenPerPair) {
                    auto genotypeLength = to!int(
                                            parents[i][0].genotype.length);
                    auto crossoverPoint = uniform(0, numberOfCities);
                    auto newborn = new Individual(config, tsp);
                    newborn.genotype = (
                        parents[i][0].genotype[0..crossoverPoint].dup
                        ~ parents[i][1].genotype[crossoverPoint ..
                        parents[i][1].genotype.length].dup);
                    children.length++;
                    children[children.length - 1] = newborn;
                }

            } else {
                foreach (j; 0 .. config.getChildrenPerPair) {
                    int parentIndex = j % config.getChildrenPerPair;
                    auto newborn = new Individual(config, tsp);
                    if (chance < config.getMutationRate) {
                        auto genotype = parents[i][0].genotype.dup;
                        int firstIndex = uniform(0, numberOfCities);
                        int secondIndex = uniform(0, numberOfCities);
                        int firstTmp = genotype[firstIndex];
                        genotype[firstIndex] = genotype[secondIndex];
                        genotype[secondIndex] = firstTmp;
                        newborn.genotype = genotype;
                    } else {
                        newborn.genotype = (
                                        parents[i][parentIndex].genotype.dup);
                    }
                    children.length++;
                    children[children.length - 1] = newborn;
                }
            }
        }
    }

    void generateInformation() {
        auto totalFitness = 0.0f;
        auto numberOfAdults = 0.0f;
        auto varianceNumerator = 0.0f;
        auto variance = 0.0f;
        foreach (i; 0 .. adults.length) {
            totalFitness += adults[i].getFitness;
            ++numberOfAdults;
        }
        averageFitness = totalFitness / numberOfAdults;
        foreach (j; 0 .. adults.length) {
            varianceNumerator += (adults[j].getFitness - averageFitness)^^2;
        }
        variance = varianceNumerator / numberOfAdults;
        standardDeviation = variance^^(1.0f/2.0f);
    }
}

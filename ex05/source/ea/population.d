module ea.population;

import ea.ea_config;
import ea.individual;
import tsp.tsp;
import pyd.pyd;
import std.algorithm;
import std.container;
import std.conv;
import std.math;
import std.random;
import std.stdio;

class Population {
    EaConfig config;
    Individual[] children;
    Individual[] adults;
    Individual[][] parents;
    float totalFitness;
    float averageFitness;
    float standardDeviation;
    int[] cities;
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

    void findObjectiveFunctionValues() {
        foreach(child; children) {
            child.calcValues();
        }
    }

    void evaluate() {
        //int[ParetoFront] fronts;
        findObjectiveFunctionValues();
        adults = children;
        if (parents) {
            foreach(parent; parents) {
                adults ~= parent[0];
                adults ~= parent[1];
            }
        }
        auto sortedAdults = adults.dup;
        writeln("sorting children");
        multiSort!("a.distanceValue < b.distanceValue", "a.costValue < b.costValue")(sortedAdults);
        writeln("amount of adults " ~ to!string(sortedAdults.length));
        for (int i = 1; i < sortedAdults.length; i++) {
            for (int j = i; j > 0; j--) {
                if (sortedAdults[i].costValue > sortedAdults[j].costValue) {
                    sortedAdults[i].dominatedBy ~= sortedAdults[j];
                }
            }
        }
        multiSort!("a.dominatedBy.length < b.dominatedBy.length", "a.distanceValue < b.distanceValue")(sortedAdults);
        int rankCounter = 0;
        float[] crowdingValues;
        crowdingValues ~= sortedAdults[0].distanceValue;
        crowdingValues ~= sortedAdults[0].costValue;
        for (int i = 0; i < sortedAdults.length; i++) {
            for (int j = 0; j < sortedAdults[i].dominatedBy.length; j++) {
                if (sortedAdults[i].dominatedBy[j].paretoRank == rankCounter) {
                    crowdingValues ~= sortedAdults[i-1].distanceValue;
                    crowdingValues ~= sortedAdults[i-1].costValue;
                    crowdingValues ~= sortedAdults[i].distanceValue;
                    crowdingValues ~= sortedAdults[i].costValue;
                    rankCounter++;
                    break;
                }
            }
            writeln("Rank counter: " ~ to!string(rankCounter));
            sortedAdults[i].paretoRank = rankCounter;
        }
        writeln(to!string(crowdingValues));

        rankCounter = 0;
        for (int i = 1; i < sortedAdults.length - 1; i++) {
            if (sortedAdults[i].paretoRank == sortedAdults[i+1].paretoRank) {
                writeln("Crowd length: " ~ to!string(crowdingValues.length));
                sortedAdults[i].crowdingDistance =
                    calculateCrowdingDistance(
                        sortedAdults[i-1],
                        sortedAdults[i+1],
                        crowdingValues[rankCounter .. rankCounter + 4]
                    );
            }
            else {
                rankCounter += 4;
                i++;
            }
        }
        foreach (adult; sortedAdults) {
            writeln(adult);
        }
    }

    float calculateCrowdingDistance(Individual previous, Individual next, float[] crowdingValues) {
        float x1 = (next.distanceValue - previous.distanceValue) / (crowdingValues[2] - crowdingValues[0]);
        float x2 = (previous.costValue - next.costValue) / (crowdingValues[1] - crowdingValues[3]);
        writeln(to!string(crowdingValues));
        return (x1) + (x2);
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
                    auto crossoverPoint = uniform(0, tsp.numberOfCities);
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
                        int firstIndex = uniform(0, tsp.numberOfCities);
                        int secondIndex = uniform(0, tsp.numberOfCities);
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

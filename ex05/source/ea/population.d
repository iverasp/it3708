module ea.population;

import ea.ea_config;
import ea.individual;
import ea.paretofront;
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
        findObjectiveFunctionValues();
        adults = children.dup;
        if (parents) {
            foreach(parent; parents) {
                adults ~= parent[0].dup;
                adults ~= parent[1].dup;
            }
        }
        writeln("number of adults: " ~ to!string(adults.length));
        auto sortedAdults = adults.dup;
        multiSort!("a.distanceValue < b.distanceValue", "a.costValue < b.costValue")(sortedAdults);
        for (int i = 1; i < sortedAdults.length; i++) {
            for (int j = i; j >= 0; j--) {
                if (sortedAdults[i].costValue > sortedAdults[j].costValue) {
                    sortedAdults[i].dominatedBy ~= sortedAdults[j];
                } else if (sortedAdults[i].distanceValue > sortedAdults[j].distanceValue
                    && sortedAdults[i].costValue == sortedAdults[j].costValue) {
                    sortedAdults[i].dominatedBy ~= sortedAdults[j];
                }
            }
        }
        multiSort!("a.dominatedBy.length < b.dominatedBy.length", "a.distanceValue < b.distanceValue")(sortedAdults);
        int rankCounter = 0;
        for (int i = 0; i < sortedAdults.length; i++) {
            for (int j = 0; j < sortedAdults[i].dominatedBy.length; j++) {
                if (sortedAdults[i].dominatedBy[j].paretoRank == rankCounter) {
                    rankCounter++;
                    break;
                }
            }
            sortedAdults[i].paretoRank = rankCounter;
        }

        multiSort!("a.paretoRank < b.paretoRank", "a.distanceValue < b.distanceValue")(sortedAdults);
        rankCounter = 0;
        ParetoFront[] fronts;
        fronts ~= new ParetoFront();
        for (int i = 0; i < sortedAdults.length; i++) {
            if (sortedAdults[i].paretoRank > rankCounter) {
                fronts[rankCounter].calc();
                ++rankCounter;
                fronts ~= new ParetoFront();
            }
            fronts[rankCounter].individuals ~= sortedAdults[i];
        }

        foreach (individual; fronts[0].individuals) {
            writeln(to!string(individual));
        }
        adults = sortedAdults.dup;
    }

    void tournamentSelection() {
        auto numberOfParents = (config.getNumberOfChildren
                                / config.getChildrenPerPair);
        auto myParents = new Individual[][](numberOfParents);
        auto newParents = 0;
        while (newParents < numberOfParents) {
            auto adultPool = adults.dup;
            randomShuffle(adultPool);
            auto groupSize = (adults.length
                                / config.getTournamentGroupSize);
            auto tournamentGroups
                = new Individual[][](groupSize, config.getTournamentGroupSize);
            auto adultIndex = adultPool.length;
            foreach(i; 0 .. groupSize) {
                foreach(j; 0 .. config.getTournamentGroupSize) {
                    if (adultIndex > 0) {
                        tournamentGroups[i][j] =
                        adultPool[--adultIndex];
                    }
                }
            }
            foreach (i; 0 .. tournamentGroups.length) {
                auto chance = uniform(0.0f, 1.0f);
                if (chance > config.getTournamentEpsilon) {
                    multiSort!("a.paretoRank < b.paretoRank",
                    "a.crowdingDistance > b.crowdingDistance")
                    (tournamentGroups[i]);
                }
                auto pair = new Individual[](2);
                pair[0] = tournamentGroups[i][0];
                pair[1] = tournamentGroups[i][1];
                myParents[newParents] = pair.dup;
                ++newParents;
            }
        }
        parents = myParents.dup;
    }

    void reproduce() {
        tournamentSelection();
        children = new Individual[](config.getNumberOfChildren);
        int childIndex = 0;
        foreach (i; 0 .. parents.length) {
            foreach (j; 0 .. config.getChildrenPerPair) {
                auto newborn = new Individual(config, tsp);
                int parentIndex = j % config.getChildrenPerPair;
                newborn.genotype = (
                                parents[i][parentIndex].genotype.dup);
                auto chance = uniform(0.0f, 1.0f);
                if (chance < config.getCrossoverRate) {
                    auto crossoverPoint = uniform(0, tsp.numberOfCities);
                    // TODO: randomize which parents genome is selected first
                    auto mutatedGenomeFirst =
                        parents[i][0].genotype[0 .. crossoverPoint].dup;
                    auto mutatedGenomeLast =
                        parents[i][1].genotype[crossoverPoint .. $].dup;
                    auto possibleCities = new int[](tsp.numberOfCities);
                    foreach(v; 0 .. tsp.numberOfCities) {
                        possibleCities[v] = v;
                    }
                    int[] duplicatedIndexes;
                    foreach(v; 0 .. crossoverPoint) {
                        possibleCities[mutatedGenomeFirst[v]] = int.max;
                    }
                    foreach(v; 0 .. mutatedGenomeLast.length) {
                        if (mutatedGenomeFirst.canFind(mutatedGenomeLast[v])) {
                            duplicatedIndexes ~= cast(int)v;
                        } else {
                            possibleCities[mutatedGenomeLast[v]] = int.max;
                        }
                    }
                    sort(possibleCities);
                    possibleCities = possibleCities[0 .. duplicatedIndexes.length];
                    randomShuffle(possibleCities);
                    foreach(v; 0 .. duplicatedIndexes.length) {
                        mutatedGenomeLast[duplicatedIndexes[v]] =
                        possibleCities[v];
                    }
                    newborn.genotype = mutatedGenomeFirst ~ mutatedGenomeLast;

                }
                chance = uniform(0.0f, 1.0f);
                if (chance < config.getMutationRate) {
                    int firstIndex = uniform(0, tsp.numberOfCities);
                    int secondIndex = uniform(0, tsp.numberOfCities);
                    int firstTmp = newborn.genotype[firstIndex];
                    newborn.genotype[firstIndex] = newborn.genotype[secondIndex];
                    newborn.genotype[secondIndex] = firstTmp;
                }
                children[childIndex++] = newborn;
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

module ea.individual;

import ea.ea_config;
import tsp.tsp;
import std.algorithm;
import std.conv;
import std.random;
import std.string;
import std.stdio;
import pyd.pyd;

class Individual {
    EaConfig config;
    TSP tsp;
    int genotypeLength;
    int[] genotype;
    float fitness;
    int distanceValue;
    int costValue;
    Individual[] dominatedBy;
    int paretoRank;
    float crowdingDistance = float.infinity;
    float random;

    this(EaConfig config, TSP tsp) {
        this.config = config;
        this.tsp = tsp;
        this.genotypeLength = config.getGenotypeLength;
        genotype = new int[](config.getGenotypeLength);
        random = uniform(0f, 1000f);
    }

    @property int[] getGenotype() { return genotype; }
    @property void setGenotype(int[] genotype) { this.genotype = genotype; }
    @property float getFitness() { return fitness; }
    @property void setFitness(float fitness) { this.fitness = fitness; }
    @property int[] getValues() { return [distanceValue, costValue]; }

    void calcValues() {
        distanceValue = tsp.getTravelValue(this.genotype, true);
        costValue = tsp.getTravelValue(this.genotype, false);
    }

    override string toString() {
        string distance = (crowdingDistance == float.infinity
            || crowdingDistance == 1f
            || crowdingDistance == 2f)
            ? "\t\tDistance: " : "\tDistance: ";
        string crowding = (paretoRank < 10) ? "\t\tCrowding: " : "\tCrowding: ";
        return "Rank: "
            ~ to!string(paretoRank)
            ~ crowding
            ~ to!string(crowdingDistance)
            ~ distance
            ~ to!string(distanceValue)
            ~ "\tCost: "
            ~ to!string(costValue)
            ~ "\tRandom: "
            ~ to!string(random);
    }

    @property auto dup() {
        Individual copy = new Individual(this.config, this.tsp);
        copy.genotype = this.genotype.dup;
        copy.distanceValue = this.distanceValue;
        copy.costValue = this.costValue;
        return copy;
    }
}

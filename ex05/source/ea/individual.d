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

    this(EaConfig config, TSP tsp) {
        this.config = config;
        this.tsp = tsp;
        this.genotypeLength = config.getGenotypeLength;
        genotype = new int[](config.getGenotypeLength);
        fitness = 0.0f;
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
        return "Rank: " ~ to!string(paretoRank) ~ " Crowding: " ~ to!string(crowdingDistance) ~ " Distance: " ~ to!string(distanceValue) ~ ", Cost: " ~ to!string(costValue);
    }

    void evaluateFitness() {

    }
}

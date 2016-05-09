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

    int opCmp(ref const Individual other) const {
        writeln("my distance: " ~ to!string(distanceValue));
        writeln("others distance: " ~ to!string(other.distanceValue));
        writeln("my cost: " ~ to!string(costValue));
        writeln("others cost: " ~ to!string(other.costValue));
        if ((this.distanceValue < other.distanceValue && this.costValue <= other.costValue) || (this.costValue < other.costValue && this.distanceValue <= other.distanceValue)) {
            writeln("i am best");
            return 1;
        }
        if (this.distanceValue == other.distanceValue && this.costValue == other.costValue) {
            writeln("i am equal");
            return 0;
        }
        writeln("i am worst");
        return -1;
    }

    void evaluateFitness() {

    }
}

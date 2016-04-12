module beertracker.evolve;

import beertracker.simulator;
import ea.ea_config;
import ea.beertrackerpopulation;
import ea.beertrackerindividual;
import ann.ctrnn;
import ann.ann_config;

import std.algorithm.sorting;

class BeerTrackerEvolve {

    float[] fittestPhenotype;
    float highestFitness;
    int avoidedBigObjects;
    int avoidedSmallObjects;
    int capturedBigObjects;
    int capturedSmallObjects;
    BeerTrackerSimulator sim;
    BeerTrackerPopulation population;
    CTRNN ann;

    this(EaConfig config) {
        this.sim = new BeerTrackerSimulator(config);
        this.population = new BeerTrackerPopulation(config);
        ann = new CTRNN(new AnnConfig(), config);
    }

    void evolve() {
        population.develop();
        foreach(child; population.getChildren) {
            ann.loadPhenotype(child.getPhenotype);
            sim.reset();
            while(!sim.completed()) {
                auto inputs = sim.getSensors();
                auto move = ann.getMove(inputs);
                sim.moveAgent(move[0], move[1]);
            }
            child.setAvoidedBigObjects(sim.getAvoidedBigObjects);
            child.setAvoidedSmallObjects(sim.getAvoidedSmallObjects);
            child.setCapturedBigObjects(sim.getCapturedBigObjects);
            child.setCapturedSmallObjects(sim.getCapturedSmallObjects);
        }
        population.evaluate();
        population.adultSelection();
        population.parentSelection();
        population.reproduce();

        auto fittetInd = population.getAdults.dup;

        bool myComp(BeerTrackerIndividual x, BeerTrackerIndividual y) @safe pure nothrow {
            return x.fitness > y.fitness;
        }
        sort!(myComp)(fittetInd);

        fittestPhenotype = fittetInd[0].getPhenotype;
        highestFitness = fittetInd[0].getFitness;
        avoidedBigObjects = fittetInd[0].getAvoidedBigObjects;
        avoidedSmallObjects = fittetInd[0].getAvoidedSmallObjects;
        capturedBigObjects = fittetInd[0].getCapturedBigObjects;
        capturedSmallObjects = fittetInd[0].getCapturedSmallObjects;
    }

    @property float[] getFittestPhenotype() { return this.fittestPhenotype; }
    @property float getHighestFitness() { return this.highestFitness; }
    @property float getAverageFitness() { return population.getAverageFitness; }
    @property float getStandardDeviation() { return population.getStandardDeviation; }
    @property int getAvoidedBigObjects() { return this.avoidedBigObjects; }
    @property int getAvoidedSmallObjects() { return this.avoidedSmallObjects; }
    @property int getCapturedBigObjects() { return this.capturedBigObjects; }
    @property int getCapturedSmallObjects() { return this.capturedSmallObjects; }

}

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
            child.setCapturedBigObjects(sim.getCapturedBigObjects);
            child.setCapturedSmallObjects(sim.getCapturedSmallObjects);
            sim.reset();
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
    }

    @property float[] getFittestPhenotype() { return this.fittestPhenotype; }
    @property float getHighestFitness() { return this.highestFitness; }
    @property float getAverageFitness() { return population.getAverageFitness; }
    @property float getStandardDeviation() { return population.getStandardDeviation; }

}

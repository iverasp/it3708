module beertracker.evolve;

import beertracker.simulator;
import ea.ea_config;

class BeerTrackerEvolve {

    float[] fittestPhenotype;
    float highestFitness;
    BeerTrackerSimulator sim;

    this(EaConfig config) {
        this.sim = new BeerTrackerSimulator(config);
    }

    void evolve() {
        foreach(i; 0 .. 100) {
            sim.reset();
            while(!sim.completed()) {
                sim.moveAgent(uniform(0,2), uniform(1,5));
            }
        }

    }

    @property float[] getFittestPhenotype() { return this.fittestPhenotype; }
    @property float getHighestFitness() { return this.highestFitness; }

}

module beertracker.evolve;

import beertracker.simulator;

class BeerTrackerEvolve {

    int timesteps;
    float[] fittestPhenotype;
    float highestFitness;
    BeerTrackerSimulator sim;

    this(int timesteps) {
        this.timesteps = timesteps;
        this.sim = new BeerTrackerSimulator(timesteps);
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

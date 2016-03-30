module dbindings;

import pyd.pyd;

import ea.population;
import ea.individual;
import ea.config;
import flatland.agent;
import flatland.simulator;
import ann.ann;

public class DBindings { }

// PyD API

extern(C) void PydMain() {
    module_init();
    wrap_class!(
        Population,
        Init!(Config),
        Repr!(Population.toString),
        Property!(Population.getAdults),
        Def!(Population.develop),
        Def!(Population.evaluate),
        Def!(Population.adultSelection),
        Def!(Population.parentSelection),
        Def!(Population.reproduce),
        Def!(Population.generateInformation)
    )();
    wrap_class!(
        Individual,
        Init!(int),
        Property!(Individual.getPhenotype),
        Property!(Individual.getFitness),
        Property!(Individual.setFitnessRange),
        Property!(Individual.getFitnessRange)
    )();
    wrap_class!(
        Agent,
        Init!(int, int),
        Def!(Agent.setX),
        Def!(Agent.setY),
        Def!(Agent.moveForward),
        Def!(Agent.turnRight),
        Def!(Agent.turnLeft),
        Def!(Agent.getX),
        Def!(Agent.getY),
        Def!(Agent.sense),
        Def!(Agent.getFoodsEaten),
        Def!(Agent.getPoisonsEaten)
    )();
    wrap_class!(
        Simulator,
        Init!(int, int, int[][], int),
        Def!(Simulator.completed),
        Def!(Simulator.move),
        Def!(Simulator.printStats),
        Def!(Simulator.getFitness),
        Def!(Simulator.getMoves)
    )();
    wrap_class!(
        Config,
        Init!(),
        Property!(Config.getPopulationSize),
        Property!(Config.getNumberOfChildren),
        Property!(Config.getGenotypeLength),
        Property!(Config.getAdultSelection),
        Property!(Config.getParentSelection),
        Property!(Config.getTournamentEpsilon),
        Property!(Config.getTournamentGroupSize),
        Property!(Config.getBoltzmannTemperature),
        Property!(Config.getBoltzmannDeltaT),
        Property!(Config.getCrossoverRate),
        Property!(Config.getChildrenPerPair),
        Property!(Config.getMutationType),
        Property!(Config.getMutationRate)
    )();
    wrap_class!(
        ANN,
        Init!(),
        Def!(ANN.setWeightsSynapsis0),
        Def!(ANN.setWeightsSynapsis1),
        Def!(ANN.predict)
    )();
}

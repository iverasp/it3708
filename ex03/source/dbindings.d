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
        Property!(Population.getChildren),
        Property!(Population.getAdults),
        Property!(Population.getAverageFitness),
        Property!(Population.getStandardDeviation),
        Def!(Population.develop),
        Def!(Population.evaluate),
        Def!(Population.adultSelection),
        Def!(Population.parentSelection),
        Def!(Population.reproduce),
        Def!(Population.generateInformation)
    )();
    wrap_class!(
        Individual,
        Init!(Config),
        Property!(Individual.getPhenotype),
        Property!(Individual.getFitness),
        Property!(Individual.setFitnessRange),
        Property!(Individual.getFitnessRange),
        Property!(Individual.setDevouredFood),
        Property!(Individual.setDevouredPoison)
    )();
    wrap_class!(
        FlatlandAgent,
        Init!(int, int),
        Def!(FlatlandAgent.setX),
        Def!(FlatlandAgent.setY),
        Def!(FlatlandAgent.moveForward),
        Def!(FlatlandAgent.turnRight),
        Def!(FlatlandAgent.turnLeft),
        Def!(FlatlandAgent.getX),
        Def!(FlatlandAgent.getY),
        Def!(FlatlandAgent.sense),
        Def!(FlatlandAgent.getFoodsEaten),
        Def!(FlatlandAgent.getPoisonsEaten)
    )();
    wrap_class!(
        FlatlandSimulator,
        Init!(int, int, int[][], int),
        Def!(FlatlandSimulator.completed),
        Def!(FlatlandSimulator.move),
        Def!(FlatlandSimulator.printStats),
        Def!(FlatlandSimulator.getMoves),
        Property!(FlatlandSimulator.getCells),
        Property!(FlatlandSimulator.getDevouredFood),
        Property!(FlatlandSimulator.getDevouredPoison),
        Property!(FlatlandSimulator.getAgent),
        Property!(FlatlandSimulator.getTotalFoods),
        Property!(FlatlandSimulator.getTotalPoisons)
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
        Property!(Config.getMutationRate),
        Property!(Config.getFoodBonus),
        Property!(Config.getPoisonPenalty)
    )();
    wrap_class!(
        ANN,
        Init!(),
        Def!(ANN.setWeightsSynapsis0),
        Def!(ANN.setWeightsSynapsis1),
        Def!(ANN.predict),
        Def!(ANN.getMove)
    )();
}

module dbindings;

import pyd.pyd;

import ea.population;
import ea.individual;
import ea.ea_config;
import flatland.agent;
import flatland.simulator;
import flatland.evolve;
import ann.ann;
import beertracker.agent;
import beertracker.object;
import beertracker.simulator;
import beertracker.evolve;
import ann.ann_config;
import ea.beertrackerindividual;
import ea.beertrackerpopulation;
import ann.ctrnn;

public class DBindings { }

// PyD API

extern(C) void PydMain() {
    module_init();
    wrap_class!(
        Population,
        Init!(EaConfig),
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
        Init!(EaConfig),
        Property!(Individual.getPhenotype),
        Property!(Individual.getFitness),
        Property!(Individual.setFitnessRange),
        Property!(Individual.getFitnessRange),
        Property!(Individual.addDevouredFood),
        Property!(Individual.addDevouredPoison)
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
        EaConfig,
        Init!(),
        Init!(int,int,int,int,string,string,float,int,float,float,float,int,string,float,float,float,float,float,float,float,bool,bool,int),
        Property!(EaConfig.getGenerations),
        Property!(EaConfig.getPopulationSize),
        Property!(EaConfig.getNumberOfChildren),
        Property!(EaConfig.getGenotypeLength),
        Property!(EaConfig.getAdultSelection),
        Property!(EaConfig.getParentSelection),
        Property!(EaConfig.getTournamentEpsilon),
        Property!(EaConfig.getTournamentGroupSize),
        Property!(EaConfig.getBoltzmannTemperature),
        Property!(EaConfig.getBoltzmannDeltaT),
        Property!(EaConfig.getCrossoverRate),
        Property!(EaConfig.getChildrenPerPair),
        Property!(EaConfig.getMutationType),
        Property!(EaConfig.getMutationRate),
        Property!(EaConfig.getFoodBonus),
        Property!(EaConfig.getPoisonPenalty),
        Property!(EaConfig.getSmallObjectBonus),
        Property!(EaConfig.getBigObjectPenalty),
        Property!(EaConfig.isNoWrap),
        Property!(EaConfig.isPullMode)
    )();
    wrap_class!(
        AnnConfig,
        Init!(),
        Property!(AnnConfig.getLayer1Function),
        Property!(AnnConfig.getLayer2Function)
    )();
    wrap_class!(
        BeerTrackerObject,
        Init!(int, int),
        Property!(BeerTrackerObject.getX),
        Property!(BeerTrackerObject.getY),
        Property!(BeerTrackerObject.getSize)
    )();
    wrap_class!(
        BeerTrackerAgent,
        Init!()
    )();
    wrap_class!(
        BeerTrackerSimulator,
        Init!(EaConfig),
        Property!(BeerTrackerSimulator.getObject),
        Property!(BeerTrackerSimulator.getAgent),
        Property!(BeerTrackerSimulator.getAvoidedBigObjects),
        Property!(BeerTrackerSimulator.getAvoidedSmallObjects),
        Property!(BeerTrackerSimulator.getCapturedBigObjects),
        Property!(BeerTrackerSimulator.getCapturedSmallObjects),
        Def!(BeerTrackerSimulator.descendObject),
        Def!(BeerTrackerSimulator.moveAgent),
        Def!(BeerTrackerSimulator.completed),
        Def!(BeerTrackerSimulator.getSensors),
        Def!(BeerTrackerSimulator.reset)
    )();
    wrap_class!(
        ANN,
        Init!(AnnConfig),
        Def!(ANN.setWeightsSynapsis0),
        Def!(ANN.setWeightsSynapsis1),
        Def!(ANN.predict),
        Def!(ANN.getMove)
    )();
    wrap_class!(
        FlatlandEvolve,
        Init!(Population, ANN, int, int, int[][][], int, bool),
        Property!(FlatlandEvolve.getHighestFitness),
        Property!(FlatlandEvolve.getFittestPhenotype),
        Def!(FlatlandEvolve.evolve),
        Def!(FlatlandEvolve.generateMap)
    )();
    wrap_class!(
        BeerTrackerEvolve,
        Init!(EaConfig),
        Property!(BeerTrackerEvolve.getHighestFitness),
        Property!(BeerTrackerEvolve.getFittestPhenotype),
        Def!(BeerTrackerEvolve.evolve),
        Property!(BeerTrackerEvolve.getStandardDeviation),
        Property!(BeerTrackerEvolve.getAverageFitness),
        Property!(BeerTrackerSimulator.getAvoidedBigObjects),
        Property!(BeerTrackerSimulator.getAvoidedSmallObjects),
        Property!(BeerTrackerSimulator.getCapturedBigObjects),
        Property!(BeerTrackerSimulator.getCapturedSmallObjects)
    )();
    wrap_class!(
        BeerTrackerIndividual,
        Init!(EaConfig),
        Property!(BeerTrackerIndividual.getPhenotype),
        Property!(BeerTrackerIndividual.getFitness),
        Property!(BeerTrackerIndividual.setFitnessRange),
        Property!(BeerTrackerIndividual.getFitnessRange),
        Property!(BeerTrackerIndividual.setAvoidedBigObjects),
        Property!(BeerTrackerIndividual.getAvoidedBigObjects),
        Property!(BeerTrackerIndividual.setAvoidedSmallObjects),
        Property!(BeerTrackerIndividual.getAvoidedSmallObjects),
        Property!(BeerTrackerIndividual.setCapturedBigObjects),
        Property!(BeerTrackerIndividual.getCapturedBigObjects),
        Property!(BeerTrackerIndividual.setCapturedSmallObjects),
        Property!(BeerTrackerIndividual.getCapturedSmallObjects)
    )();
    wrap_class!(
        BeerTrackerPopulation,
        Init!(EaConfig),
        Repr!(BeerTrackerPopulation.toString),
        Property!(BeerTrackerPopulation.getChildren),
        Property!(BeerTrackerPopulation.getAdults),
        Property!(BeerTrackerPopulation.getAverageFitness),
        Property!(BeerTrackerPopulation.getStandardDeviation),
        Def!(BeerTrackerPopulation.develop),
        Def!(BeerTrackerPopulation.evaluate),
        Def!(BeerTrackerPopulation.adultSelection),
        Def!(BeerTrackerPopulation.parentSelection),
        Def!(BeerTrackerPopulation.reproduce),
        Def!(BeerTrackerPopulation.generateInformation)
    )();
    wrap_class!(
        CTRNN,
        Init!(AnnConfig, EaConfig),
        Def!(CTRNN.setWeightsSynapsis0),
        Def!(CTRNN.setWeightsSynapsis1),
        Def!(CTRNN.setGains0),
        Def!(CTRNN.setGains1),
        Def!(CTRNN.setTimeConstants0),
        Def!(CTRNN.setTimeConstants1),
        Def!(CTRNN.getMove),
        Def!(CTRNN.loadPhenotype),
        Def!(CTRNN.predict)
    )();
}

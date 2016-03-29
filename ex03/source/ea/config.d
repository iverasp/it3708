module ea.config;

class Config {
    this(){
    }

    auto populationSize = 100;
    auto numberOfChildren = 100;
    auto genotypeLength = 100;
    auto adultSelection = "f";
    auto parentSelection = "t";
    auto tournamentEpsilon = 0.15;
    auto tournamentGroupSize = 20;
    auto boltzmannTemperature = 1.;
    auto boltzmannDeltaT = 0.01;
    auto crossoverRate = 0.01;
    auto childrenPerPair = 2;
    auto mutationType = "g";
    auto mutationRate = 1;

    @property auto getPopulationSize(){ return populationSize; }
    @property auto getNumberOfChildren(){ return numberOfChildren; }
    @property auto getGenotypeLength(){ return genotypeLength; }
    @property auto getAdultSelection(){ return adultSelection; }
    @property auto getParentSelection(){ return parentSelection; }
    @property auto getTournamentEpsilon(){ return tournamentEpsilon; }
    @property auto getTournamentGroupSize(){ return tournamentGroupSize; }
    @property auto getBoltzmannTemperature(){ return boltzmannTemperature; }
    @property auto getBoltzmannDeltaT(){ return boltzmannDeltaT; }
    @property auto getCrossoverRate(){ return crossoverRate; }
    @property auto getChildrenPerPair(){ return childrenPerPair; }
    @property auto getMutationType(){ return mutationType; }
    @property auto getMutationRate(){ return mutationRate; }
}

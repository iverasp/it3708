module ea.config;

class Config {
    this(){
    }

    // EA config
    // Generic variables
    auto generations = 50;
    auto populationSize = 200;
    auto numberOfChildren = 200;
    auto genotypeLength = 18 * 16; // 6 * 3
    auto adultSelection = "g";
    auto parentSelection = "t";
    auto tournamentEpsilon = 0.1f;
    auto tournamentGroupSize = 20;
    auto boltzmannTemperature = 1.0f;
    auto boltzmannDeltaT = 0.01f;
    auto crossoverRate = 0.5f;
    auto childrenPerPair = 2;
    auto mutationType = "g";
    auto mutationRate = 1.0f;

    // Problem specific variables
    auto foodBonus = 1.0f;
    auto poisonPenalty = 5.0f;


    // EA getters
    // Generic getters
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

    // Problem specific variable
    @property auto getFoodBonus(){ return foodBonus; }
    @property auto getPoisonPenalty(){ return poisonPenalty; }
}

module ann.ann_config;

class AnnConfig {
    this(){
    }

    // ANN config
	auto layer1Function = "s";
	auto layer2Function = "s";

    // ANN getters
    @property auto getLayer1Function(){ return layer1Function; }
    @property auto getLayer2Function(){ return layer2Function; }
}

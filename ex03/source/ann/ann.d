module ann.ann;

import ann.ann_config;
import ann.matrix;
import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.numeric;
import std.range;
import std.stdio;
import std.string;

class ANN {

    AnnConfig config;
    Matrix synapsis0;
    Matrix synapsis1;

    this(AnnConfig config) {
        this.config = config;
        this.synapsis0 = new Matrix();
        this.synapsis1 = new Matrix();
    }

    void setWeightsSynapsis0(float[][] weights) {
        this.synapsis0.matrix = weights;
    }

    void setWeightsSynapsis1(float[][] weights) {
        this.synapsis1.matrix = weights;
    }

    float[][] predict(int[][] input) {
        auto layer0 = new Matrix(input);
        //writeln("\nlayer0 or input: ", layer0);
        auto layer1 = (layer0 * synapsis0);

        switch(config.getLayer1Function) {
            case("s"):
                layer1.nonLinear();
                break;
            default:
                break;
            // put activation functions here
        }

        //writeln("layer1 or ouput: ", layer1);
        float[][] result = layer1.toArray();
        return result;

        /**
        auto layer1 = (layer0 * synapsis0).nonLinear();
        writeln("layer1 or hidden: ", layer1);
        auto layer2 = layer1 * synapsis1;
        writeln("layer2 or output: ", layer2);
        float[][] result = layer2.nonLinear().toArray();
        writeln("result (toarray?): ", result);
        return result;
        */
    }

    int getMove(int[][] input) {
        auto moves = predict(input);
        float max = 0;
        int move = 0;
        foreach(i; 0 .. moves[0].length) {
            if (moves[0][i] > max) {
                move = cast(int)i;
                max = moves[0][i];
            }
        }
        //writeln("move: ", move);
        return move;
    }
}

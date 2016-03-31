module ann.ann;

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

    Matrix synapsis0;
    Matrix synapsis1;

    this() {
        this.synapsis0 = new Matrix();
        this.synapsis1 = new Matrix();
    }

    void setWeightsSynapsis0(double[][] weights) {
        this.synapsis0.matrix = weights;
    }

    void setWeightsSynapsis1(double[][] weights) {
        this.synapsis1.matrix = weights;
    }

    double[][] predict(double[][] input) {
        auto layer0 = new Matrix(input);
        auto layer1 = (layer0 * synapsis0).nonLinear();
        auto layer2 = layer1 * synapsis1;
        double[][] result = layer2.nonLinear().toArray();
        return result;
    }

    int getMove(double[][] input) {
        auto moves = predict(input);
        double max = 0;
        int move = 0;
        foreach(i; 0 .. moves.length) {
            if (moves[i][0] > max) {
                move = cast(int)i;
                max = moves[i][0];
            }
        }
        return move;
    }
}

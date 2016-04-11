module ann.ctrnn;

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

class CTRNN {

    AnnConfig config;
    Matrix synapsis0;
    Matrix synapsis1;
    float[] neuronStates;
    float[] timeConstants0;
    float[] timeConstants1;
    float[] gains0;
    float[] gains1;

    this(AnnConfig config) {
        this.config = config;
        this.synapsis0 = new Matrix();
        this.synapsis1 = new Matrix();
        this.neuronStates = new float[](4);
        this.timeConstants0 = new float[](2);
        this.timeConstants1 = new float[](2);
        this.gains0 = new float[](2);
        this.gains1 = new float[](2);
    }

    void setWeightsSynapsis0(float[][] weights) {
        this.synapsis0.matrix = weights;
    }

    void setWeightsSynapsis1(float[][] weights) {
        this.synapsis1.matrix = weights;
    }

    void setTimeConstants0(float[] t) {
        this.timeConstants0 = t;
    }

    void setTimeConstants1(float[] t) {
        this.timeConstants1 = t;
    }

    void setGains0(float[] g) {
        this.gains0 = g;
    }

    void setGains1(float[] g) {
        this.gains1 = g;
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
    }

    int getSteps(float n) {
        if (n < 0.2) return 0;
        if (n < 0.4) return 1;
        if (n < 0.6) return 2;
        if (n < 0.8) return 3;
        return 4;
    }

    int[] getMove(int[] inputs) {
        auto predicted = predict([inputs]);
        float left = predicted[0][0];
        float right = predicted[0][1];
        left = cast(int)getSteps(left);
        right = cast(int)getSteps(right);
        if ((left - right) < 0) return [1, cast(int)abs(left - right)];
        return [-1, cast(int)abs(right - left)];

    }
}

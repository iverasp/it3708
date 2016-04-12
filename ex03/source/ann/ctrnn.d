module ann.ctrnn;

import ann.ann_config;
import ann.matrix;
import ea.ea_config;
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
    EaConfig eaconfig;
    Matrix synapsis0;
    Matrix synapsis1;
    float[] neuronStates0;
    float[] neuronStates1;
    float[] timeConstants0;
    float[] timeConstants1;
    float[] gains0;
    float[] gains1;

    this(AnnConfig config, EaConfig eaconfig) {
        this.config = config;
        this.eaconfig = eaconfig;
        this.synapsis0 = new Matrix();
        this.synapsis1 = new Matrix();
        this.neuronStates0 = new float[](2);
        this.neuronStates0[0] = 0.0f;
        this.neuronStates0[1] = 0.0f;
        this.neuronStates1 = new float[](2);
        this.neuronStates1[0] = 0.0f;
        this.neuronStates1[1] = 0.0f;
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

    float gainSigmoid(float gain, float neuronState) {
		return 1f/(1f+exp(-gain * neuronState));
    }

    float deltaState(float signal, float[] neuronStates, float[] timeConstants,
                    int index) {
        return (signal - neuronStates[index]) / timeConstants[index];
    }

    float[][] predict(int[] input) {
        int inputWeightsLength = 5;
        if (eaconfig.noWrap) inputWeightsLength += 2;
        float[] myInput = new float[](inputWeightsLength + 3);
        myInput[0] = 1.0f;
        myInput[1] = gainSigmoid(gains0[0], neuronStates0[0]);
        myInput[2] = gainSigmoid(gains0[1], neuronStates0[1]);
        foreach(i; 0 .. inputWeightsLength) {
            myInput[i+3] = cast(float)input[i];
        }
        auto layer0 = new Matrix([myInput]);
        auto layer1 = (layer0 * synapsis0);
        layer1.nonLinear();
        neuronStates0[0] += deltaState(layer1.matrix[0][0], neuronStates0,
                            timeConstants0, 0);
        neuronStates0[1] += deltaState(layer1.matrix[0][1], neuronStates0,
                            timeConstants0, 1);
        myInput = new float[](5);
        myInput[0] = 1.0f;
        myInput[1] = gainSigmoid(gains1[0], neuronStates1[0]);
        myInput[2] = gainSigmoid(gains1[1], neuronStates1[1]);
        myInput[3 .. 5] = layer1.matrix[0];
        layer1 = new Matrix([myInput]);
        auto layer2 = (layer1 * synapsis1);
        layer2.nonLinear();
        neuronStates1[0] += deltaState(layer2.matrix[0][0], neuronStates1,
                            timeConstants1, 0);
        neuronStates1[1] += deltaState(layer2.matrix[0][1], neuronStates1,
                            timeConstants1, 1);

        float[][] result = layer2.toArray();
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
        auto predicted = predict(inputs);
        float left = predicted[0][0];
        float right = predicted[0][1];
        left = getSteps(left);
        right = getSteps(right);
        int[] result = [0, 0];
        if (right > left) result = [1, cast(int)(right - left)];
        else if (left > right) result = [0, cast(int)(left - right)];
        return result;

    }
}

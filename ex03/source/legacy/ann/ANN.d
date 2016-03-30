module ann.ann;

import std.stdio;
import std.random;
import std.conv;
import std.string;
import std.math;
import std.numeric;
import std.range;
import std.array;
import std.algorithm;

import ann.matrix;

public class ANN {

  Matrix input;
  Matrix output;
  Matrix synapsis0;
  Matrix synapsis1;

  this() {
    input = new Matrix([[0,0,1],
            [0,1,1],
            [1,0,1],
            [1,1,1]]);
    output = new Matrix([[0], [1], [1], [0]]);
    synapsis0 = new Matrix(3,4);
    synapsis0.randomize();
    synapsis1 = new Matrix(4,1);
    synapsis1.randomize();
  }

  /* returns a 2d array of size height x width,
    initialized with random values [start, end) */
  private double[][] getWeight(int height, int width, int start, int end) {
    double[][] result = new double[][](height, width);
    foreach (i; 0 .. height) {
      foreach (j; 0 .. width) {
        result[i][j] = uniform(to!float(start), to!float(end));
      }
    }
    return result;
  }



  private double getError(double[] error) {
    double result = 0f;
    foreach(i; 0 .. error.length) {
      result += abs(error[i]);
    }
    return result / error.length;
  }

  public void learn(int range) {
    foreach(i; 0 .. range) {

      auto layer0 = input.dup();
      //writeln(to!string(layer0));
      //writeln(to!string(synapsis0));
      auto layer1 = (layer0 * synapsis0).nonLinear();
      //writeln(to!string(layer1));
      //writeln(to!string(synapsis1));
      auto layer2 = layer1 * synapsis1;
      auto layer2Error = output - layer2;
      //if (i % 10000 == 0) writeln(getError(error[0]));

      auto a = layer2.nonLinear(true);

      auto layer2Delta = layer2Error * layer2.nonLinear(true);

      auto layer1Error = layer2Delta * synapsis1;

      auto layer1Delta = layer1Error * layer1.nonLinear(true);

      auto temp0 = layer0.transpose() * layer1Delta;
      auto temp1 = layer1.transpose() * layer2Delta;

      writeln(to!string(synapsis0));
      writeln(to!string(temp0));
      //synapsis0 = synapsis0 + temp0;
      synapsis1 = synapsis1 + temp1;


    }
  }

}

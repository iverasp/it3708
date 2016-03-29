import std.stdio;
import std.random;
import std.conv;
import std.string;
import std.math;
import std.numeric;
import std.range;
import std.array;
import std.algorithm;

import scid;

public class NN {

  double[][] input;
  double[][] output;
  double[][] synapsis0;
  double[][] synapsis1;

  this() {
    input = [[0,0,1],
            [0,1,1],
            [1,0,1],
            [1,1,1]];
    output = [[0],
              [1],
              [1],
              [0]];
    synapsis0 = getWeight(to!int(input[0].length), to!int(input.length), -1, 1);
    synapsis1 = getWeight(to!int(output[0].length), to!int(output.length), -1, 1);
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

  private double[][] nonLinear(double[][] x, bool derivative) {
    //if (derivative) return x * (1f-x);
    double[][] result = new double[][](x.length, x[0].length);
    foreach(i; 0 .. x.length) {
      foreach(j; 0 .. x[0].length) {
        if (derivative) result[i][j] = x[i][j] * (1-x[i][j]);
        else result[i][j] = 1f/(1f+exp(-x[i][j]));
      }
    }
    return result;
  }

  T[][] matMul(T)(in T[][] A, in T[][] B) pure nothrow /*@safe*/ {
      const Bt = B[0].length.iota.map!(i=> B.transversal(i).array).array;
      return A.map!(a => Bt.map!(b => a.dotProduct(b)).array).array;
  }

  public void runNN(int range) {
    foreach(i; 0 .. range) {
      auto layer0 = input.dup;
      auto layer1 = nonLinear(matMul(layer0, synapsis0), false);
      auto layer2 = nonLinear(matMul(synapsis1, layer1), false);

    }
  }

}

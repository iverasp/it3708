module ann.matrix;

import std.random;
import std.string;
import std.conv;
import std.stdio;
import std.range, std.array, std.numeric, std.algorithm;
import std.math;

public class Matrix {

  double[][] matrix;

  this() {}

  this(int height, int width) {
    matrix = new double[][](height, width);
  }

  this(double[][] mat) {
    matrix = mat;
  }

  public double[][] toArray() { return this.matrix; }

  override string toString() {
    return to!string(matrix);
  }

  public Matrix dup() {
    return new Matrix(matrix.dup);
  }

  public void randomize() {
    foreach(i; 0 .. matrix.length) {
      foreach(j; 0 .. matrix[0].length) {
        //matrix[i][j] = uniform(-1.0f, 1.0f);
        matrix[i][j] = uniform(-1, 1);
      }
    }
  }

  Matrix nonLinear(bool derivative = false) {
    auto result = new double[][](matrix.length, matrix[0].length);
    foreach(i; 0 .. matrix.length) {
      foreach(j; 0 .. matrix[0].length) {
        if (derivative) result[i][j] = matrix[i][j] * (1-matrix[i][j]);
        else result[i][j] = 1f/(1f+exp(-matrix[i][j]));
      }
    }
    return new Matrix(result);
  }

  Matrix opBinaryRight(string op)(Matrix other)if(op=="-") {
    auto result = new Matrix(to!int(matrix.length), to!int(matrix[0].length));
    foreach(i; 0 .. matrix.length) {
      result.matrix[i][] = other.matrix[i][] - matrix[i][];
    }
    return result;
  }

  Matrix transpose() {
    return new Matrix(transpose(matrix));
  }

  T[][] transpose(T)(in T[][] m) pure nothrow {
    auto r = new typeof(return)(m[0].length, m.length);
    foreach (immutable nr, const row; m)
        foreach (immutable nc, immutable c; row)
            r[nc][nr] = c;
    return r;
}

  Matrix opBinaryRight(string op)(Matrix other)if(op=="+") {
    auto result = new Matrix(to!int(matrix.length), to!int(matrix[0].length));
    foreach(i; 0 .. matrix.length) {
      result.matrix[i][] = other.matrix[i][] + matrix[i][];
    }
    return result;
  }

  Matrix opBinaryRight(string op)(Matrix other)if(op=="*") {
    if (matrix.length == other.matrix[0].length)
      return new Matrix(matrixMultiplication(other.matrix, matrix));
    //if (matrix.length == other.matrix.length)
      return new Matrix(matrixMultiplication2(other.matrix, matrix));
  }

  Matrix opBinaryRight(string op)(double n)if(op=="*") {
    auto result = new double[][](matrix.length, matrix[0].length);
    foreach(i; 0 .. matrix.length) {
      foreach(j; 0 .. matrix[0].length) {
        result[i][j] = matrix[i][j] * n;
      }
    }
    return new Matrix(result);
  }

  T[][] matrixMultiplication(T)(in T[][] A, in T[][] B) pure nothrow /*@safe*/ {
      const Bt = B[0].length.iota.map!(i=> B.transversal(i).array).array;
      return A.map!(a => Bt.map!(b => a.dotProduct(b)).array).array;
  }

  T[][] matrixMultiplication2(T)(in T[][] A, in T[][] B) pure nothrow {
    auto result = new double[][](A.length, A[0].length);
    foreach (i; 0 .. A.length) {
      foreach (j; 0 .. A[0].length) {
        result[i][j] = A[i][j] * B[i][j];
      }
    }
    return result;
  }

}

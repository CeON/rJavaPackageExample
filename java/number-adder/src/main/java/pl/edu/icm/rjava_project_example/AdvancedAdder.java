package pl.edu.icm.rjava_project_example;

import Jama.Matrix;

/**
 * Adding more advanced numerical structures.
 * 
 * The methods are static to show how to handle them from R code.
 * 
 * @author Mateusz Kobos
 */
public class AdvancedAdder {
	/**
	 * Add vectors. They have to be of the same length.
	 */
	public static double[] addVectors(double[] x, double[] y){
		if(x.length != y.length){
			throw new RuntimeException(String.format(
				"The input arrays are not of the same length "+
				"(x.length=%d, y.length=%d)", x.length, y.length));
		}
		double[] result = new double[x.length];
		for(int i = 0; i < x.length; i++){
			result[i] = x[i] + y[i];
		}
		return result;
	}
	
	/**
	 * Add matrices. Their number of rows and columns has to match. The code
	 * uses a 3rd party library.
	 */
	public static double[][] addMatrices(double[][]x, double[][] y){
		Matrix xm = new Matrix(x);
		Matrix ym = new Matrix(y);
		Matrix result = xm.plus(ym);
		return result.getArray();
	}
}

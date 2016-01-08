package pl.edu.icm.rjava_project_example;

/**
 * Adds two numbers. 
 * 
 * The parameters to be added are passed in the constructor
 * to show how to handle creating new class instances and interrogating them 
 * from R code.
 * 
 * @author Mateusz Kobos
 */
public class SimpleAdder {
	private double x;
	private double y;
	
	public SimpleAdder(double x, double y){
		this.x = x;
		this.y = y;
	}
	
	public double getResult(){
		return x + y;
	}
}

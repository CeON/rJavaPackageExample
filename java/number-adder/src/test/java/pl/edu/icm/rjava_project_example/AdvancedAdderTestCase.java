package pl.edu.icm.rjava_project_example;

import static org.junit.Assert.*;
import org.junit.Test;

/**
 * @author Mateusz Kobos
 */
public class AdvancedAdderTestCase {
	
	private static double EPSILON = 0.000001;
	
	@Test
	public void testAddVectors(){
		assertArrayEquals(new double[]{3, 0, 0}, 
				AdvancedAdder.addVectors(new double[]{1, 0, -1}, 
						new double[]{2, 0, 1}), 
				EPSILON);
	}
	
	@Test(expected=RuntimeException.class)
	public void testDifferentLengths(){
		AdvancedAdder.addVectors(new double[]{1, 0, -1, 4}, 
				new double[]{2, 0, 1});
	}
	
	@Test
	public void testAddMatrices(){
		double[][] expected = {
			{3, 0},
			{0, 4},
			{5, 6}
		};
		
		double[][] x = {
			{1, 0},
			{-1, 1},
			{2, 3}
		};
		
		double[][] y = {
			{2, 0},
			{1, 3},
			{3, 3}
		};
		
		double[][] actual = AdvancedAdder.addMatrices(x, y);
		
		assertEquals(expected.length, actual.length);
		for(int r = 0; r < actual.length; r++){
			assertArrayEquals(expected[r], actual[r], EPSILON);
		}
	}

}

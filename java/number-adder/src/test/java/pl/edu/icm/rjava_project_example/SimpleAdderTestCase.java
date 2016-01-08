package pl.edu.icm.rjava_project_example;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

/**
 * @author Mateusz Kobos
 */
public class SimpleAdderTestCase {
	private static double EPSILON = 0.000001;

	@Test
	public void testAddNumbers() {
		assertEquals(3, new SimpleAdder(1, 2).getResult(), EPSILON);
		assertEquals(0, new SimpleAdder(0, 0).getResult(), EPSILON);
		assertEquals(0, new SimpleAdder(-1, 1).getResult(), EPSILON);
	}
}

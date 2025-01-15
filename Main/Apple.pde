public class Apple {
    // Radius (down) r_d ~ 3f
    PShape model;
    PVector position, prevPosition, velocity, prevVelocity, acceleration;
    float mass, v_t; // in kg

    Apple() {
        model = loadShape("apple.obj");
        mass = 0.1f;
        position = new PVector(0, 10, 0);
        prevPosition = new PVector(0, 50f, 0);
        velocity = new PVector(0, 0, 0);
        prevVelocity = new PVector(0, 0, 0);
        acceleration = new PVector(0, 0, 0);
        v_t = calculateTerminalVelocity();
    }

    // As of right now everything is constant as earth's gravity is always assumed. Subject to change
    float calculateTerminalVelocity() {
        // Terminal velocity is the maximum velocity that an object can reach during free fall
        // Terminal velocity is given by the equation: v_t = sqrt((2 * m * g) / (p * A * C_d))
        return sqrt((2 * mass * 9.81f) / (1.225f/*Air Density (Avg)*/ * 0.2827f/*Cross-sectional area of the apple in m^2*/ * 0.47f/*Drag coefficient for the apple*/));
    }
}

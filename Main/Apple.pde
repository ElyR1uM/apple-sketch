public class Apple {
    // Radius (down) r_d ~ 3f
    PShape model;
    PVector position, prevPosition, velocity, prevVelocity, acceleration;
    float mass, v_t, g, p , C_d; // in kg
    int state; // 0 = Fall, 1 = Collide, 2 = Throw, 3 = Idle
    boolean wasThrown;

    Apple() {
        model = loadShape("apple.obj");
        mass = 0.25f;
        position = new PVector(0, 11f, 0);
        prevPosition = new PVector(0, 11f, 0);
        velocity = new PVector(0, 0, 0);
        prevVelocity = new PVector(0, 0, 0);
        acceleration = new PVector(0, 0, 0);
        state = 0;
        g = 9.81f;
        p = 1.225f;
        C_d = 0.47f;
        wasThrown = false;
        v_t = calculateTerminalVelocity();
    }

    // As of right now everything is constant as earth's gravity is always assumed. Subject to change
    float calculateTerminalVelocity() {
        // Terminal velocity is the maximum velocity that an object can reach during free fall
        // Terminal velocity is given by the equation: v_t = sqrt((2 * m * g) / (p * A * C_d))
        return sqrt((2 * mass * g) / (p/*Air Density (Avg)*/ * 0.2827f/*Cross-sectional area of the apple in m^2*/ * 0.47f/*Drag coefficient for the apple*/));
    }
}

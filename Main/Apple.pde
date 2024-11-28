public class Apple {
    // Radius (down) r_d = 3.75f
    PShape model;
    PVector position, prevPosition;
    float mass; // in kg
    float velocity, prevVelocity, acceleration;
    boolean grounded;

    Apple() {
        model = loadShape("apple.obj");
        mass = 0.1f;
        position = new PVector(0, 0, 0);
        prevPosition = new PVector(0, 0, 0);
        grounded = false;
        velocity = 0f;
    }
}

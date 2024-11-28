public class Apple {
    // Radius (down) r_d ~ 3f
    PShape model;
    PVector position, prevPosition;
    float mass; // in kg
    float velocity, prevVelocity, acceleration;

    Apple() {
        model = loadShape("apple.obj");
        mass = 0.1f;
        position = new PVector(0, 0, 0);
        prevPosition = new PVector(0, 0, 0);
        velocity = 0f;
    }
}

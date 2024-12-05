public class Apple {
    // Radius (down) r_d ~ 3f
    PShape model;
    PVector position, prevPosition, velocity, prevVelocity, acceleration;
    float mass; // in kg

    Apple() {
        model = loadShape("apple.obj");
        mass = 0.1f;
        position = new PVector(0, 0, 0);
        prevPosition = new PVector(0, 0, 0);
        velocity = new PVector(0, 0, 0);
        prevVelocity = new PVector(0, 0, 0);
        acceleration = new PVector(0, 0, 0);
    }
}

public class Apple {
    // Radius (down) r_d = 3.75f
    PShape model;
    PVector position;
    float mass; // in kg
    boolean grounded;

    Apple() {
        model = loadShape("apple.obj");
        mass = 0.1f;
        position = new PVector(0, 0, 0);
        grounded = false;
    }
}

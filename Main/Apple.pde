public class Apple {
    PShape model;
    float velocity;
    float mass; // in kg
    PVector position;

    Apple() {
        model = loadShape("apple.obj");
        mass = 0.1f;
        position = new PVector(0, 0, 0);
    }
}
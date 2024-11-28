public class World {
    PShape model;
    PVector position;

    World() {
        model = loadShape("platform.obj");
        position = new PVector(0f, -50f, 0f);
    }
}

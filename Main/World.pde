public class World {
    PShape model;
    PVector position;

    World() {
        model = loadShape("island.obj");
        position = new PVector(0f, -50f, 0f);
    }
}

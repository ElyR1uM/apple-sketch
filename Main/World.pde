public class World {
    PShape model;
    PVector position;

    World() {
        model = loadShape("platform.obj");
        position = new PVector(0f, -13.75f, 0f);
    }
}

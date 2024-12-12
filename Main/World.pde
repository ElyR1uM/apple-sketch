public class World {
    PShape model;
    PVector position;
    float r_w; // Radius of the world ~ 345f

    World() {
        r_w = 345f;
        model = loadShape("platform.obj");
        position = new PVector(0f, -50f, 0f);
    }
}

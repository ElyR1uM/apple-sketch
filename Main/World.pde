public class World {
    PShape model;
    PVector position;
    ArrayList<PVector> surfaceVertexMesh;
    float r_w; // Radius of the world ~ 345f

    World() {
        surfaceVertexMesh = new ArrayList<PVector>();
        r_w = 345f;
        model = loadShape("island.obj");
        position = new PVector(0f, -50f - r_w, 0f);
    }
}

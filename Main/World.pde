public class World {
    PShape model;
    PVector position;
    ArrayList<PVector> surfaceVertexMesh;
    float r_w; // Radius of the world ~ 345f

    World() {
        surfaceVertexMesh = new ArrayList<PVector>();
        r_w = 49.4f;
        model = loadShape("island.obj");
        position = new PVector(197.5f, r_w, 110f);
    }
}

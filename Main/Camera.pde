// If I want to code my own camera

/*import java.awt.Toolkit;

final static float screenDPI = Toolkit.getDefaultToolkit().getScreenResolution();
final static float spinThreshhold = 0.0001;

World world;
Camera singleton;

class Camera {
    // Current Properties
    PVector targetPos;
    float pitch, yaw, zoom;

    // Target Properties
    PVector targetCenterPos;
    float targetPitch, targetYaw, targetZoom;
    float mouseSensitivity;

    Camera() {
        singleton = this;
        targetPos = world.position;
        setFOV(60);
        
    }

    void setFOV() {
            this.fov = max(30, min(120, fov));
        }
}
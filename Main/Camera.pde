import java.awt.toolkit;

final static float screenDPI = Toolkit.getDefaultToolkit().getScreenResolution();
final static float spinThreshhold = 0.0001;

Camera singleton;

class Camera {
    // Current Properties
    PVector targetPos;
    float pitch, yaw, zoom;

    // Target Properties
    float targetPitch, targetYaw, targetZoom
    float mouseSensitivity;
}
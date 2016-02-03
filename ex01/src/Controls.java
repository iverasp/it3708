import javafx.scene.layout.Pane;

/**
 * Created by iver on 03/02/16.
 */
public class Controls {

    private int separationWeight;
    private int alignmentWeight;
    private int cohesionWeight;

    public Controls(int separationWeight, int alignmentWeight, int cohesionWeight) {
        this.separationWeight = separationWeight;
        this.alignmentWeight = alignmentWeight;
        this.cohesionWeight = cohesionWeight;
    }

    public int getSeparationWeight() {
        return separationWeight;
    }

    public void setSeparationWeight(int separationWeight) {
        this.separationWeight = separationWeight;
    }

    public int getAlignmentWeight() {
        return alignmentWeight;
    }

    public void setAlignmentWeight(int alignmentWeight) {
        this.alignmentWeight = alignmentWeight;
    }

    public int getCohesionWeight() {
        return cohesionWeight;
    }

    public void setCohesionWeight(int cohesionWeight) {
        this.cohesionWeight = cohesionWeight;
    }
}

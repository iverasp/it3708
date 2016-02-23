import ai.EA;
import ai.LOLZ;
import ai.OneMax;
import javafx.scene.layout.Pane;

/**
 * Created by iver on 23/02/16.
 */
public class Simulator extends Pane {

    private Runnable onStart = () -> {};

    public void setOnStart(Runnable onStart)
    {
        this.onStart = onStart;
    }

    public Simulator() {
        /*
        EA runner1 = new EA(
                new OneMax(40, false), // problem
                600, // population size
                10, // generations
                0.05, //epsilon
                0.8, // crossover rate
                0.01, // mutation rate
                0.5, // adult to child ratio
                8, // k
                1.0, // threshold,
                40 // genotype size
        );
        runner1.solveProblem();
        */
        EA runner1 = new EA(
                new LOLZ(21, 40), // problem
                600, // population size
                10, // generations
                0.05, //epsilon
                0.8, // crossover rate
                0.01, // mutation rate
                0.5, // adult to child ratio
                8, // k
                1.0, // threshold,
                40 // genotype size
        );
        runner1.solveProblem();
    }
}

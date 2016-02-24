package core;

import ai.EA;
import ai.OneMax;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

/**
 * Created by iver on 23/02/16.
 */
public class Simulator extends Pane implements Listener, Runnable {

    private Runnable onStart = () -> {};

    public void setOnStart(Runnable onStart)
    {
        this.onStart = onStart;
    }

    XYChart.Series maxSeries;
    XYChart.Series avgSeries;
    XYChart.Series stdSeries;
    LineChart<Number,Number> lineChart;

    public Simulator(Stage stage) {
        final NumberAxis xAxis = new NumberAxis();
        final NumberAxis yAxis = new NumberAxis();
        xAxis.setLabel("Time");
        yAxis.setLabel("Value");
        stage.setTitle("Evolution");
        lineChart = new LineChart<>(xAxis,yAxis);
        maxSeries = new XYChart.Series();
        maxSeries.setName("Max");
        avgSeries= new XYChart.Series();
        avgSeries.setName("Avg");
        stdSeries = new XYChart.Series();
        stdSeries.setName("Std");
        lineChart.getData().addAll(maxSeries, avgSeries, stdSeries);
        Scene scene = new Scene(lineChart, 800, 600);
        stage.setScene(scene);
        stage.show();
    }

    public void runEA() {

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
        runner1.add(this);
        runner1.solveProblem();
        /*
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
        runner1.add(this);
        runner1.solveProblem();
        */
    }

    public void register(Observable observable) {observable.add(this);}
    public void unregister(Observable observable) {observable.remove(this);}

    public void fieldChanged(Object source, String attribute) {
        //System.out.println("FIELD CHANGED!");
        switch(attribute) {
            case "STD":
                System.out.println("STD: " + ((EA) source).getLastestStd());
                stdSeries.getData().add(new XYChart.Data(getTimeSinceStart(), ((EA) source).getLastestStd()));
                break;
            case "MAX":
                System.out.println("MAX: " + ((EA) source).getLastestMax());
                maxSeries.getData().add(new XYChart.Data(getTimeSinceStart(), ((EA) source).getLastestMax()));
                break;
            case "AVG":
                System.out.println("AVG: " + ((EA) source).getLastestAvg());
                avgSeries.getData().add(new XYChart.Data(getTimeSinceStart(), ((EA) source).getLastestAvg()));
                break;

        }
    }

    @Override
    public void run() {
        runEA();
    }

    int lol = 1;
    public int getTimeSinceStart() {
        return lol++;
    }

}

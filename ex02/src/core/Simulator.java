package core;

import ai.*;
import javafx.application.Platform;
import javafx.concurrent.Service;
import javafx.concurrent.Task;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

import java.util.concurrent.CountDownLatch;

/**
 * Created by iver on 23/02/16.
 */
public class Simulator extends Pane implements Listener {

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
        xAxis.setLabel("Generation");
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
        service.start();
    }

    public void runEA() {


        EA runner1 = new EA(
                new SurprisingSequence(20, 35, 150), // problem
                500, // population size
                20000, // generations
                0.05, //epsilon
                0.09, // crossover rate
                0.01, // mutation rate
                0.3, // adult to child ratio
                8, // k
                1.0, // threshold,
                35 // genotype size
        );
        runner1.add(this);
        runner1.solveProblem();


        /*
        EA runner1 = new EA(
                new LocalSurprisingSequence(20,250, 150), // problem
                500, // population size
                20000, // generations
                0.05, //epsilon
                0.85, // crossover rate
                0.009, // mutation rate
                0.3, // adult to child ratio
                32, // k
                1.0, // threshold,
                250 // genotype size
        );
        runner1.add(this);
        runner1.solveProblem();
        */

        /*
        EA runner1 = new EA(
                new OneMax(40, false), // problem
                800, // population size
                100, // generations
                0.05, //epsilon
                0.99, // crossover rate
                0.001, // mutation rate
                0.5, // adult to child ratio
                8, // k
                1.0, // threshold,
                40 // genotype size
        );
        runner1.add(this);
        runner1.solveProblem();
        */

        /*
        EA runner1 = new EA(
                new LOLZ(21, 40), // problem
                1500, // population size
                100, // generations
                0.05, //epsilon
                0.99, // crossover rate
                0.001, // mutation rate
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
                //System.out.println("STD: " + ((EA) source).getLastestStd());
                stdSeries.getData().add(new XYChart.Data(getTimeSinceStart(), ((EA) source).getLastestStd()));
                break;
            case "MAX":
                //System.out.println("MAX: " + ((EA) source).getLastestMax());
                maxSeries.getData().add(new XYChart.Data(getTimeSinceStart(), ((EA) source).getLastestMax()));
                break;
            case "AVG":
                //System.out.println("AVG: " + ((EA) source).getLastestAvg());
                avgSeries.getData().add(new XYChart.Data(getTimeSinceStart(), ((EA) source).getLastestAvg()));
                break;

        }
    }

    /*
    @Override
    public void run() {
        runEA();
    }
    */

    int lol = 1;
    public int getTimeSinceStart() {
        lol++;
        return lol/3;
    }

    Service<Void> service = new Service<Void>() {
        @Override
        protected Task<Void> createTask() {
            return new Task<Void>() {
                @Override
                protected Void call() throws Exception {
                    //Background work
                    final CountDownLatch latch = new CountDownLatch(1);
                    Platform.runLater(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                runEA();
                            } finally {
                                latch.countDown();
                            }
                        }
                    });
                    latch.await();
                    //Keep with the background work
                    return null;
                }
            };
        }
    };


}

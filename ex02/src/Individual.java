/**
 * Created by iver on 15/02/16.
 */
public class Individual {

    private boolean mature;
    private String genotype;
    private String phenotype;
    private double fitness;

    public Individual(String genotype) {
        this.genotype = genotype;
        this.mature = false;
        this.phenotype = "";
        this.fitness = 0;
    }

    public boolean isMature() {
        return mature;
    }

    public void setMature(boolean mature) {
        this.mature = mature;
    }

    public String getGenotype() {
        return genotype;
    }

    public void setGenotype(String genotype) {
        this.genotype = genotype;
    }

    public String getPhenotype() {
        return phenotype;
    }

    public void setPhenotype(String phenotype) {
        this.phenotype = phenotype;
    }

    public double getFitness() {
        return fitness;
    }

    public void setFitness(double fitness) {
        this.fitness = fitness;
    }
}

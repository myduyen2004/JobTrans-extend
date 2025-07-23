package jobtrans.model;

/**
 * @author MyDuyen
 */

public class DigitalProduct {
    private int digitalProductId;
    private int jobId;
    private int senderId;
    private String digitalProductUrl;
    private String notes;
    private String status;

    // Constructors
    public DigitalProduct() {}

    public DigitalProduct(int digitalProductId, int jobId, int senderId,
                          String digitalProductUrl, String notes, String status) {
        this.digitalProductId = digitalProductId;
        this.jobId = jobId;
        this.senderId = senderId;
        this.digitalProductUrl = digitalProductUrl;
        this.notes = notes;
        this.status = status;
    }

    // Getters and Setters
    public int getDigitalProductId() {
        return digitalProductId;
    }

    public void setDigitalProductId(int digitalProductId) {
        this.digitalProductId = digitalProductId;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public String getDigitalProductUrl() {
        return digitalProductUrl;
    }

    public void setDigitalProductUrl(String digitalProductUrl) {
        this.digitalProductUrl = digitalProductUrl;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

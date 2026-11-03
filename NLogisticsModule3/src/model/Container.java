package model;

public class Container {

    private Long containerId;
    private String containerNumber;
    private String type;
    private String size;
    private String imageUrl;

    private Double tareWeightKg;
    private Double maxGrossWeightKg;
    private Double goodsCapacityKg;
    private Double goodsCapacityCbm;

    private String status;
    private Long currentPortId;
    private Long ownerCompanyId;

    public Long getContainerId() {
        return containerId;
    }

    public void setContainerId(Long containerId) {
        this.containerId = containerId;
    }

    public String getContainerNumber() {
        return containerNumber;
    }

    public void setContainerNumber(String containerNumber) {
        this.containerNumber = containerNumber;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Double getTareWeightKg() {
        return tareWeightKg;
    }

    public void setTareWeightKg(Double tareWeightKg) {
        this.tareWeightKg = tareWeightKg;
    }

    public Double getMaxGrossWeightKg() {
        return maxGrossWeightKg;
    }

    public void setMaxGrossWeightKg(Double maxGrossWeightKg) {
        this.maxGrossWeightKg = maxGrossWeightKg;
    }

    public Double getGoodsCapacityKg() {
        return goodsCapacityKg;
    }

    public void setGoodsCapacityKg(Double goodsCapacityKg) {
        this.goodsCapacityKg = goodsCapacityKg;
    }

    public Double getGoodsCapacityCbm() {
        return goodsCapacityCbm;
    }

    public void setGoodsCapacityCbm(Double goodsCapacityCbm) {
        this.goodsCapacityCbm = goodsCapacityCbm;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getCurrentPortId() {
        return currentPortId;
    }

    public void setCurrentPortId(Long currentPortId) {
        this.currentPortId = currentPortId;
    }

    public Long getOwnerCompanyId() {
        return ownerCompanyId;
    }

    public void setOwnerCompanyId(Long ownerCompanyId) {
        this.ownerCompanyId = ownerCompanyId;
    }
}
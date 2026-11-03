package model;

import java.sql.Date;
import java.sql.Timestamp;

public class DemandForecast {

    private Long forecastId;
    private String containerType;
    private Long routeId;
    private Date forecastPeriod;

    private Integer forecastedDemand;
    private Double forecastedPrice;

    private String algorithmVersion;
    private Timestamp generatedAt;

    public Long getForecastId() {
        return forecastId;
    }

    public void setForecastId(Long forecastId) {
        this.forecastId = forecastId;
    }

    public String getContainerType() {
        return containerType;
    }

    public void setContainerType(String containerType) {
        this.containerType = containerType;
    }

    public Long getRouteId() {
        return routeId;
    }

    public void setRouteId(Long routeId) {
        this.routeId = routeId;
    }

    public Date getForecastPeriod() {
        return forecastPeriod;
    }

    public void setForecastPeriod(Date forecastPeriod) {
        this.forecastPeriod = forecastPeriod;
    }

    public Integer getForecastedDemand() {
        return forecastedDemand;
    }

    public void setForecastedDemand(Integer forecastedDemand) {
        this.forecastedDemand = forecastedDemand;
    }

    public Double getForecastedPrice() {
        return forecastedPrice;
    }

    public void setForecastedPrice(Double forecastedPrice) {
        this.forecastedPrice = forecastedPrice;
    }

    public String getAlgorithmVersion() {
        return algorithmVersion;
    }

    public void setAlgorithmVersion(String algorithmVersion) {
        this.algorithmVersion = algorithmVersion;
    }

    public Timestamp getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(Timestamp generatedAt) {
        this.generatedAt = generatedAt;
    }
}
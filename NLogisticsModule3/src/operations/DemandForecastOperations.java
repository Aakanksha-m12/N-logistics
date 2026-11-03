
package operations;

import java.sql.Date;
import java.util.List;

import model.DemandForecast;

public interface DemandForecastOperations {

    void add(DemandForecast forecast);

    List<DemandForecast> showAll();

    List<DemandForecast> showByCompany(Long companyId);

    /*
     * Get forecast records for the next N periods.
     *
     * Default number of periods is handled by the controller/service
     * as 6.
     */
    List<DemandForecast> getNextPeriods(
            String containerType,
            Long routeId,
            int numberOfPeriods);

    /*
     * Get forecast data specifically for the
     * predictive demand/price graph.
     */
    List<DemandForecast> getPriceTrend(
            String containerType,
            Long routeId,
            int numberOfPeriods);

    /*
     * Generate a forecast for ONE future period.
     *
     * forecastedDemand, demandMultiplier and algorithmVersion
     * are supplied by the forecasting service.
     *
     * The database procedure:
     * generate_demand_forecast(...)
     *
     * uses these values through authenticated database-session
     * variables and calculates the forecasted price.
     */
    void generateForecast(
            String containerType,
            Long routeId,
            Date forecastPeriod,
            Integer forecastedDemand,
            Double demandMultiplier,
            String algorithmVersion);
}


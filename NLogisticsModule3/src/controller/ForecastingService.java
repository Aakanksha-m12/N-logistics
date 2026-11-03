
package controller;

import java.util.ArrayList;
import java.util.List;

/*
 * ============================================================
 * FORECASTING SERVICE
 * ============================================================
 *
 * Algorithm:
 * Simple Moving Average
 *
 * Version:
 * Forecast-v1
 *
 * Purpose:
 * Predict future demand using actual historical demand values.
 *
 * IMPORTANT:
 * This class does NOT create fake historical data.
 * Historical demand must be supplied by Module 2 or another
 * legitimate historical-data source.
 *
 * Example:
 *
 * Historical demand:
 * 100, 120, 110
 *
 * Window = 3
 *
 * Forecast:
 * (100 + 120 + 110) / 3
 * = 110
 *
 * For multiple future periods, the calculated forecast is
 * added to the history and used for the next prediction.
 * ============================================================
 */

public class ForecastingService {

    /*
     * Current algorithm version.
     */
    public static final String ALGORITHM_VERSION =
            "Forecast-v1";


    /*
     * Default moving-average window.
     *
     * The last 3 historical periods are used.
     */
    private static final int DEFAULT_WINDOW = 3;


    /*
     * ============================================================
     * FORECAST NEXT N PERIODS
     * ============================================================
     *
     * @param historicalDemand
     *        Actual historical demand values.
     *
     * @param numberOfPeriods
     *        Number of future periods to predict.
     *
     * @return List containing forecasted demand for each
     *         future period.
     */
    public List<Integer> forecastNextPeriods(
            List<Integer> historicalDemand,
            int numberOfPeriods) {

        validateHistoricalDemand(historicalDemand);

        if (numberOfPeriods <= 0) {

            throw new IllegalArgumentException(
                    "Number of forecast periods must be greater than zero."
            );
        }

        /*
         * Maximum 24 periods.
         */
        if (numberOfPeriods > 24) {

            numberOfPeriods = 24;
        }


        /*
         * Copy the historical values.
         *
         * We do not modify the original list.
         */
        List<Integer> workingHistory =
                new ArrayList<Integer>(
                        historicalDemand
                );


        List<Integer> forecasts =
                new ArrayList<Integer>();


        /*
         * Generate each future period.
         */
        for (int i = 0;
             i < numberOfPeriods;
             i++) {

            int forecast =
                    calculateMovingAverage(
                            workingHistory
                    );

            forecasts.add(forecast);

            /*
             * Add the forecast to the working history.
             *
             * This allows the next future period to be
             * calculated using the previous forecast.
             */
            workingHistory.add(forecast);
        }


        return forecasts;
    }


    /*
     * ============================================================
     * CALCULATE ONE MOVING-AVERAGE FORECAST
     * ============================================================
     */

    private int calculateMovingAverage(
            List<Integer> history) {

        if (history == null ||
                history.isEmpty()) {

            throw new IllegalArgumentException(
                    "Historical demand is required."
            );
        }


        /*
         * Use the last 3 values when available.
         *
         * If fewer than 3 values exist, use all available
         * historical values.
         */
        int windowSize =
                Math.min(
                        DEFAULT_WINDOW,
                        history.size()
                );


        long total = 0;


        int startIndex =
                history.size() - windowSize;


        for (int i = startIndex;
             i < history.size();
             i++) {

            Integer value =
                    history.get(i);

            if (value == null ||
                    value < 0) {

                throw new IllegalArgumentException(
                        "Historical demand values cannot be negative or null."
                );
            }

            total += value;
        }


        /*
         * Round to the nearest whole demand unit.
         */
        return (int) Math.round(
                (double) total / windowSize
        );
    }


    /*
     * ============================================================
     * CALCULATE DEMAND MULTIPLIER
     * ============================================================
     *
     * Demand multiplier compares the forecasted demand
     * with the historical average demand.
     *
     * Formula:
     *
     * Demand Multiplier =
     *
     * Forecasted Demand
     * ------------------
     * Historical Average
     *
     * Example:
     *
     * Historical average = 100
     * Forecasted demand  = 120
     *
     * Multiplier = 120 / 100
     *             = 1.20
     *
     * This multiplier can then be supplied to the Module 3
     * pricing stored procedure.
     */
    public double calculateDemandMultiplier(
            List<Integer> historicalDemand,
            int forecastedDemand) {

        validateHistoricalDemand(historicalDemand);


        if (forecastedDemand < 0) {

            throw new IllegalArgumentException(
                    "Forecasted demand cannot be negative."
            );
        }


        long total = 0;


        for (Integer value :
                historicalDemand) {

            if (value == null ||
                    value < 0) {

                throw new IllegalArgumentException(
                        "Historical demand values cannot be negative or null."
                );
            }

            total += value;
        }


        double historicalAverage =
                (double) total
                / historicalDemand.size();


        /*
         * If historical demand is zero, there is no valid
         * ratio to calculate.
         *
         * Do not invent an arbitrary multiplier.
         */
        if (historicalAverage <= 0) {

            throw new IllegalArgumentException(
                    "Historical average demand must be greater than zero."
            );
        }


        double multiplier =
                forecastedDemand
                / historicalAverage;


        /*
         * Round to 4 decimal places because the database
         * stores demand_multiplier as DECIMAL(10,4).
         */
        return Math.round(
                multiplier * 10000.0
        ) / 10000.0;
    }


    /*
     * ============================================================
     * VALIDATE HISTORICAL DATA
     * ============================================================
     */

    private void validateHistoricalDemand(
            List<Integer> historicalDemand) {

        if (historicalDemand == null ||
                historicalDemand.isEmpty()) {

            throw new IllegalArgumentException(
                    "Actual historical demand data is required."
            );
        }


        for (Integer value :
                historicalDemand) {

            if (value == null ||
                    value < 0) {

                throw new IllegalArgumentException(
                        "Historical demand values cannot be negative or null."
                );
            }
        }
    }
}


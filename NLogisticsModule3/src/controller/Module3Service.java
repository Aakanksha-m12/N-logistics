
package controller;

import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import implementors.Company_Operations_Implementor;
import implementors.Container_Operations_Implementor;
import implementors.DemandForecast_Operations_Implementor;
import implementors.PricingAudit_Operations_Implementor;
import implementors.PricingRule_Operations_Implementor;

import model.Company;
import model.Container;
import model.DemandForecast;
import model.PricingAudit;
import model.PricingRule;

public class Module3Service {

    private Container_Operations_Implementor containerImplementor;
    private PricingRule_Operations_Implementor pricingRuleImplementor;
    private PricingAudit_Operations_Implementor pricingAuditImplementor;
    private DemandForecast_Operations_Implementor forecastImplementor;
    private Company_Operations_Implementor companyImplementor;

    /*
     * Forecasting algorithm service.
     *
     * This class performs the actual forecasting calculation.
     */
    private ForecastingService forecastingService;


    public Module3Service() {

        containerImplementor =
                new Container_Operations_Implementor();

        pricingRuleImplementor =
                new PricingRule_Operations_Implementor();

        pricingAuditImplementor =
                new PricingAudit_Operations_Implementor();

        forecastImplementor =
                new DemandForecast_Operations_Implementor();

        companyImplementor =
                new Company_Operations_Implementor();

        forecastingService =
                new ForecastingService();
    }


    /*
     * ============================================================
     * COMPANY
     * ============================================================
     */

    public List<Company> getActiveCompanies(
            Integer userId) {

        requireUser(userId);

        return companyImplementor.showActiveCompanies();
    }


    public Company getCompany(
            Long companyId,
            Integer userId) {

        requireUser(userId);

        if (companyId == null) {
            throw new IllegalArgumentException(
                    "Company ID is required.");
        }

        Company company =
                companyImplementor.findById(companyId);

        if (company == null) {
            throw new RuntimeException(
                    "Company not found.");
        }

        if (!"Active".equalsIgnoreCase(
                company.getApprovalStatus())) {

            throw new SecurityException(
                    "Company is not active.");
        }

        return company;
    }


    /*
     * ============================================================
     * ROUTES
     * ============================================================
     */

    public List<Long> getAvailableRouteIds(
            Integer userId) {

        requireUser(userId);

        return pricingRuleImplementor
                .getAvailableRouteIds();
    }


    /*
     * ============================================================
     * CONTAINER - ADD
     * ============================================================
     */

    public void addContainer(
            Container container,
            Integer userId,
            Long companyId) {

        requireUser(userId);
        requireCompany(companyId);

        if (container == null) {
            throw new IllegalArgumentException(
                    "Container is required.");
        }

        /*
         * Company identity comes from the
         * authenticated session.
         */
        container.setOwnerCompanyId(companyId);

        /*
         * Every newly added container starts
         * as Available.
         */
        container.setStatus("Available");

        containerImplementor.add(container);
    }


    /*
     * ============================================================
     * CONTAINER - GET ONE
     * ============================================================
     */

    public Container getContainer(
            Long containerId,
            Integer userId) {

        requireUser(userId);

        if (containerId == null) {
            throw new IllegalArgumentException(
                    "Container ID is required.");
        }

        return containerImplementor.findById(containerId);
    }


    /*
     * ============================================================
     * CONTAINER - UPDATE
     * ============================================================
     */

    public void updateContainer(
            Container container,
            Integer userId,
            Long companyId) {

        requireUser(userId);
        requireCompany(companyId);

        if (container == null ||
                container.getContainerId() == null) {

            throw new IllegalArgumentException(
                    "Container and container ID are required.");
        }

        Container existing =
                containerImplementor.findById(
                        container.getContainerId());

        if (existing == null) {
            throw new RuntimeException(
                    "Container not found.");
        }

        /*
         * Company Admin / Staff can update only
         * their own company's container.
         */
        if (existing.getOwnerCompanyId() == null ||
                !companyId.equals(
                        existing.getOwnerCompanyId())) {

            throw new SecurityException(
                    "You cannot update another company's container.");
        }

        /*
         * Container number cannot be changed.
         */
        container.setContainerNumber(
                existing.getContainerNumber());

        /*
         * Ownership cannot be changed.
         */
        container.setOwnerCompanyId(companyId);

        /*
         * Status cannot be changed through
         * normal container editing.
         */
        container.setStatus(existing.getStatus());

        containerImplementor.update(container);
    }


    /*
     * ============================================================
     * CONTAINER - DELETE
     * ============================================================
     */

    public void deleteContainer(
            Container container,
            Integer userId,
            Long companyId) {

        requireUser(userId);
        requireCompany(companyId);

        if (container == null ||
                container.getContainerId() == null) {

            throw new IllegalArgumentException(
                    "Container and container ID are required.");
        }

        Container existing =
                containerImplementor.findById(
                        container.getContainerId());

        if (existing == null) {
            throw new RuntimeException(
                    "Container not found.");
        }

        /*
         * Cannot delete another company's container.
         */
        if (existing.getOwnerCompanyId() == null ||
                !companyId.equals(
                        existing.getOwnerCompanyId())) {

            throw new SecurityException(
                    "You cannot delete another company's container.");
        }

        container.setOwnerCompanyId(companyId);

        containerImplementor.delete(container);
    }


    /*
     * ============================================================
     * CONTAINER RETRIEVAL - COMPANY
     * ============================================================
     */

    public List<Container> getContainersByCompany(
            Long companyId,
            Integer userId) {

        requireUser(userId);
        requireCompany(companyId);

        return containerImplementor.showByCompany(
                companyId);
    }


    public List<Container> getAvailableContainersByCompany(
            Long companyId,
            Integer userId) {

        requireUser(userId);
        requireCompany(companyId);

        return containerImplementor
                .showAvailableByCompany(companyId);
    }


    /*
     * ============================================================
     * CONTAINER RETRIEVAL - ALL
     * ============================================================
     *
     * Used by Super Admin.
     */

    public List<Container> getAllocatedContainersByCompany(
            Long companyId,
            Integer userId) {

        requireUser(userId);
        requireCompany(companyId);

        return containerImplementor.showByCompany(companyId);
    }


    public List<Container> getAllContainers(
            Integer userId) {

        requireUser(userId);

        return containerImplementor.showAll();
    }


    /*
     * ============================================================
     * CONTAINER RETRIEVAL - ALL AVAILABLE
     * ============================================================
     */

    public List<Container> getAvailableContainers(
            Integer userId) {

        requireUser(userId);

        return containerImplementor.showAvailable();
    }


    /*
     * ============================================================
     * ALLOCATION
     * ============================================================
     */

    public void allocateContainer(
            Long containerId,
            Double cargoWeightKg,
            Double cargoVolumeCbm,
            Integer userId,
            Long companyId) {

        requireUser(userId);
        requireCompany(companyId);

        if (containerId == null) {
            throw new IllegalArgumentException(
                    "Container ID is required.");
        }

        if (cargoWeightKg == null ||
                cargoWeightKg < 0) {

            throw new IllegalArgumentException(
                    "Cargo weight cannot be negative.");
        }

        if (cargoVolumeCbm == null ||
                cargoVolumeCbm < 0) {

            throw new IllegalArgumentException(
                    "Cargo volume cannot be negative.");
        }

        containerImplementor.allocate(
                containerId,
                cargoWeightKg,
                cargoVolumeCbm,
                companyId);
    }


    /*
     * ============================================================
     * RELEASE
     * ============================================================
     */

    public void releaseContainer(
            Long containerId,
            Integer userId,
            Long companyId) {

        requireUser(userId);
        requireCompany(companyId);

        if (containerId == null) {
            throw new IllegalArgumentException(
                    "Container ID is required.");
        }

        containerImplementor.release(
                containerId,
                companyId);
    }


    /*
     * ============================================================
     * PRICING RULE - ADD
     * ============================================================
     */

    public void addPricingRule(
            PricingRule pricingRule,
            Integer userId) {

        requireUser(userId);

        if (pricingRule == null) {
            throw new IllegalArgumentException(
                    "Pricing rule is required.");
        }

        /*
         * Never trust finalPrice supplied by browser.
         */
        pricingRule.setFinalPrice(null);

        pricingRuleImplementor.add(
                pricingRule);
    }


    /*
     * ============================================================
     * PRICING RULE - UPDATE
     * ============================================================
     */

    public void updatePricingRule(
            PricingRule pricingRule,
            Integer userId,
            String reason) {

        requireUser(userId);

        if (pricingRule == null ||
                pricingRule.getPricingId() == null) {

            throw new IllegalArgumentException(
                    "Pricing rule and pricing ID are required.");
        }

        if (reason == null ||
                reason.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Reason is required for pricing changes.");
        }

        PricingRule existing =
                pricingRuleImplementor.findById(
                        pricingRule.getPricingId());

        if (existing == null) {
            throw new IllegalArgumentException(
                    "Pricing rule not found.");
        }

        Double oldPrice =
                existing.getFinalPrice();

        /*
         * Never trust finalPrice from browser.
         */
        pricingRule.setFinalPrice(null);

        /*
         * Implementor calculates the new final price.
         */
        pricingRuleImplementor.update(
                pricingRule);

        Double newPrice =
                pricingRule.getFinalPrice();

        /*
         * Audit only when final price changes.
         */
        if (!samePrice(oldPrice, newPrice)) {

            PricingAudit audit =
                    new PricingAudit();

            audit.setPricingId(
                    pricingRule.getPricingId());

            audit.setOldPrice(oldPrice);

            audit.setNewPrice(newPrice);

            /*
             * Authenticated user ID.
             */
            audit.setChangedBy(
                    userId.longValue());

            audit.setReason(
                    reason.trim());

            pricingAuditImplementor.add(
                    audit);
        }
    }


    /*
     * ============================================================
     * PRICING RULE - VIEW
     * ============================================================
     */

    public List<PricingRule> getAllPricingRules(
            Integer userId) {

        requireUser(userId);

        return pricingRuleImplementor.showAll();
    }


    /*
     * ============================================================
     * PRICING RULE - DETAILS
     * ============================================================
     */

    public PricingRule getPricingRule(
            Long pricingId,
            Integer userId) {

        requireUser(userId);

        if (pricingId == null) {
            throw new IllegalArgumentException(
                    "Pricing ID is required.");
        }

        return pricingRuleImplementor.findById(
                pricingId);
    }


    /*
     * ============================================================
     * INTERNAL PRICING CALCULATION
     * ============================================================
     */

    public PricingRule calculatePricing(
            String containerType,
            String containerSize,
            Long routeId,
            Integer userId) {

        requireUser(userId);

        return pricingRuleImplementor
                .calculateFinalPrice(
                        containerType,
                        containerSize,
                        routeId);
    }


    /*
     * ============================================================
     * CUSTOMER-SAFE FINAL PRICE
     * ============================================================
     */

    public PricingRule getCustomerFinalPrice(
            String containerType,
            String containerSize,
            Long routeId,
            Integer userId) {

        requireUser(userId);

        PricingRule rule =
                pricingRuleImplementor
                        .calculateFinalPrice(
                                containerType,
                                containerSize,
                                routeId);

        if (rule == null) {
            return null;
        }

        /*
         * Completely new object.
         */
        PricingRule customerRule =
                new PricingRule();

        /*
         * ONLY final price is exposed.
         */
        customerRule.setFinalPrice(
                rule.getFinalPrice());

        return customerRule;
    }


    /*
     * ============================================================
     * PRICING AUDIT - ADD
     * ============================================================
     */

    public void addPricingAudit(
            PricingAudit audit,
            Integer userId) {

        requireUser(userId);

        if (audit == null) {
            throw new IllegalArgumentException(
                    "Pricing audit is required.");
        }

        /*
         * Never trust changed_by from browser.
         */
        audit.setChangedBy(
                userId.longValue());

        pricingAuditImplementor.add(
                audit);
    }


    /*
     * ============================================================
     * PRICING AUDIT - VIEW
     * ============================================================
     */

    public List<PricingAudit> getAllPricingAudits(
            Integer userId) {

        requireUser(userId);

        return pricingAuditImplementor.showAll();
    }


    /*
     * ============================================================
     * DEMAND FORECAST - ADD
     * ============================================================
     */

    public void addDemandForecast(
            DemandForecast forecast,
            Integer userId) {

        requireUser(userId);

        if (forecast == null) {
            throw new IllegalArgumentException(
                    "Demand forecast is required.");
        }

        forecastImplementor.add(
                forecast);
    }


    /*
     * ============================================================
     * DEMAND FORECAST - GENERATE ONE PERIOD
     * ============================================================
     *
     * This method is used when the forecasting algorithm has
     * already calculated the values.
     *
     * No historical data is fabricated here.
     */

    public void generateDemandForecast(
            String containerType,
            Long routeId,
            Date forecastPeriod,
            Integer forecastedDemand,
            Double demandMultiplier,
            String algorithmVersion,
            Integer userId) {

        requireUser(userId);

        if (containerType == null ||
                containerType.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container type is required.");
        }

        if (routeId == null) {

            throw new IllegalArgumentException(
                    "Route ID is required.");
        }

        if (forecastPeriod == null) {

            throw new IllegalArgumentException(
                    "Forecast period is required.");
        }

        if (forecastedDemand == null ||
                forecastedDemand < 0) {

            throw new IllegalArgumentException(
                    "Forecasted demand cannot be negative.");
        }

        if (demandMultiplier == null ||
                demandMultiplier < 0) {

            throw new IllegalArgumentException(
                    "Demand multiplier cannot be negative.");
        }

        if (algorithmVersion == null ||
                algorithmVersion.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Algorithm version is required.");
        }

        forecastImplementor.generateForecast(
                containerType.trim(),
                routeId,
                forecastPeriod,
                forecastedDemand,
                demandMultiplier,
                algorithmVersion.trim()
        );
    }


    /*
     * ============================================================
     * DEMAND FORECAST - GENERATE FROM HISTORICAL DATA
     * ============================================================
     *
     * THIS IS THE IMPORTANT CONNECTION.
     *
     * Flow:
     *
     * Module 2 historical demand
     *             |
     *             v
     *     ForecastingService
     *             |
     *             v
     *    Future demand values
     *             |
     *             v
     *   Demand multiplier
     *             |
     *             v
     * DemandForecast implementor
     *             |
     *             v
     *    Module 3 database
     *
     * Historical demand MUST come from a legitimate source.
     *
     * This method does not create historical data.
     */

    public List<DemandForecast> generateForecastFromHistory(
            String containerType,
            Long routeId,
            List<Integer> historicalDemand,
            int numberOfPeriods,
            Integer userId) {

        requireUser(userId);

        /*
         * Internal forecast access.
         *
         * Controller authorization should restrict this
         * functionality to the permitted internal roles.
         */

        if (containerType == null ||
                containerType.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Container type is required.");
        }

        if (routeId == null) {

            throw new IllegalArgumentException(
                    "Route ID is required.");
        }

        if (historicalDemand == null ||
                historicalDemand.isEmpty()) {

            throw new IllegalArgumentException(
                    "Actual historical demand data is required.");
        }

        if (numberOfPeriods <= 0) {

            throw new IllegalArgumentException(
                    "Number of forecast periods "
                    + "must be greater than zero.");
        }

        if (numberOfPeriods > 24) {

            numberOfPeriods = 24;
        }


        /*
         * --------------------------------------------------------
         * STEP 1
         * Run the Simple Moving Average algorithm.
         * --------------------------------------------------------
         */

        List<Integer> forecastValues =
                forecastingService.forecastNextPeriods(
                        historicalDemand,
                        numberOfPeriods);


        /*
         * --------------------------------------------------------
         * STEP 2
         * Create a working history.
         *
         * Previous forecasts are added so that every future
         * period can be calculated sequentially.
         * --------------------------------------------------------
         */

        List<Integer> workingHistory =
                new ArrayList<Integer>(
                        historicalDemand);


        /*
         * --------------------------------------------------------
         * STEP 3
         * Start with the first day of the next month.
         * --------------------------------------------------------
         *
         * Example:
         *
         * Current month = September 2026
         *
         * First forecast = October 2026
         * Second forecast = November 2026
         * Third forecast = December 2026
         */

        Calendar calendar =
                Calendar.getInstance();

        calendar.set(
                Calendar.DAY_OF_MONTH,
                1
        );

        calendar.add(
                Calendar.MONTH,
                1
        );


        List<DemandForecast> generatedForecasts =
                new ArrayList<DemandForecast>();


        /*
         * --------------------------------------------------------
         * STEP 4
         * Store every future forecast.
         * --------------------------------------------------------
         */

        for (int i = 0;
             i < forecastValues.size();
             i++) {

            Integer forecastedDemand =
                    forecastValues.get(i);


            /*
             * Calculate the demand multiplier using the
             * historical/working demand available at this point.
             *
             * This makes the multiplier period-specific.
             */
            double demandMultiplier =
                    forecastingService
                            .calculateDemandMultiplier(
                                    workingHistory,
                                    forecastedDemand);


            /*
             * Convert Calendar date to java.sql.Date.
             */
            Date forecastPeriod =
                    new Date(
                            calendar.getTimeInMillis()
                    );


            /*
             * Send calculated values to Module 3.
             *
             * The database procedure then calculates
             * forecasted_price from:
             *
             * base_price
             * × seasonal_multiplier
             * × demand_multiplier
             */
            generateDemandForecast(
                    containerType,
                    routeId,
                    forecastPeriod,
                    forecastedDemand,
                    demandMultiplier,
                    ForecastingService.ALGORITHM_VERSION,
                    userId
            );


            /*
             * Add the forecast to working history.
             *
             * This allows future calculations to continue
             * sequentially.
             */
            workingHistory.add(
                    forecastedDemand);


            /*
             * Move to the next month.
             */
            calendar.add(
                    Calendar.MONTH,
                    1
            );
        }


        /*
         * --------------------------------------------------------
         * STEP 5
         * Read the newly generated future records.
         * --------------------------------------------------------
         */

        generatedForecasts =
                forecastImplementor.getNextPeriods(
                        containerType,
                        routeId,
                        numberOfPeriods);


        return generatedForecasts;
    }


    /*
     * ============================================================
     * DEMAND FORECAST - VIEW
     * ============================================================
     */

    public List<DemandForecast> getPriceTrend(
            String containerType,
            Long routeId,
            int numberOfPeriods,
            Integer userId) {

        requireUser(userId);

        /*
         * Default to 6 periods.
         */
        if (numberOfPeriods <= 0) {

            numberOfPeriods = 6;
        }

        /*
         * Prevent an unnecessarily large graph request.
         */
        if (numberOfPeriods > 24) {

            numberOfPeriods = 24;
        }

        return forecastImplementor.getPriceTrend(
                containerType,
                routeId,
                numberOfPeriods
        );
    }


    /*
     * ============================================================
     * NEXT FORECAST PERIODS
     * ============================================================
     */

    public List<DemandForecast> getNextForecastPeriods(
            String containerType,
            Long routeId,
            int numberOfPeriods,
            Integer userId) {

        requireUser(userId);

        if (numberOfPeriods <= 0) {

            throw new IllegalArgumentException(
                    "Number of forecast periods "
                    + "must be greater than zero.");
        }

        if (numberOfPeriods > 24) {

            numberOfPeriods = 24;
        }

        return forecastImplementor.getNextPeriods(
                containerType,
                routeId,
                numberOfPeriods);
    }


    /*
     * ============================================================
     * PRICE COMPARISON
     * ============================================================
     */

    private boolean samePrice(
            Double oldPrice,
            Double newPrice) {

        if (oldPrice == null &&
                newPrice == null) {

            return true;
        }

        if (oldPrice == null ||
                newPrice == null) {

            return false;
        }

        return Double.compare(
                oldPrice,
                newPrice) == 0;
    }


    /*
     * ============================================================
     * SECURITY - USER
     * ============================================================
     */

    private void requireUser(
            Integer userId) {

        if (userId == null) {

            throw new SecurityException(
                    "Login required.");
        }
    }


    /*
     * ============================================================
     * SECURITY - COMPANY
     * ============================================================
     */

    private void requireCompany(
            Long companyId) {

        if (companyId == null) {

            throw new SecurityException(
                    "Company context is required.");
        }
    }
}


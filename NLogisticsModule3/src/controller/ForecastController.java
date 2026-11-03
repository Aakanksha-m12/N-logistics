
package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.DemandForecast;

@WebServlet("/forecast")
public class ForecastController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private Module3Service service;


    @Override
    public void init() throws ServletException {

        service = new Module3Service();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }


    /*
     * ============================================================
     * PROCESS FORECAST REQUEST
     * ============================================================
     */

    private void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        try {

            /*
             * ====================================================
             * LOGIN
             * ====================================================
             */

            Integer userId =
                    Module3Authorization.requireLogin(
                            session);


            /*
             * ====================================================
             * ACTION
             * ====================================================
             */

            String action =
                    request.getParameter("action");


            if (action == null ||
                    action.trim().isEmpty()) {

                action = "view";
            }


            /* =====================================================
             * VIEW FORECAST
             * ===================================================== */

            if ("view".equalsIgnoreCase(action)) {

                /*
                 * Forecasting is an internal management feature.
                 *
                 * Customer and other unauthorized roles cannot
                 * access this page directly through the URL.
                 */
                requireForecastAccess(session);


                /*
                 * =================================================
                 * READ REQUEST VALUES
                 * =================================================
                 */

                String containerType =
                        request.getParameter(
                                "containerType");


                String routeIdValue =
                        request.getParameter(
                                "routeId");


                String periodsValue =
                        request.getParameter(
                                "periods");


                /*
                 * =================================================
                 * FIRST PAGE LOAD
                 * =================================================
                 *
                 * If no container type or route has been selected,
                 * simply display the forecast page.
                 */

                if (containerType == null ||
                        containerType.trim().isEmpty() ||
                        routeIdValue == null ||
                        routeIdValue.trim().isEmpty()) {

                    setCommonAttributes(
                            request,
                            session
                    );

                    request.getRequestDispatcher(
                            "/WEB-INF/views/forecast.jsp"
                    ).forward(
                            request,
                            response
                    );

                    return;
                }


                /*
                 * =================================================
                 * VALIDATE CONTAINER TYPE
                 * =================================================
                 */

                containerType =
                        containerType.trim();


                /*
                 * =================================================
                 * PARSE ROUTE ID
                 * =================================================
                 */

                Long routeId =
                        parseLong(
                                routeIdValue,
                                "Route ID"
                        );


                /*
                 * =================================================
                 * NUMBER OF PERIODS
                 * =================================================
                 *
                 * Default = 6
                 * Maximum = 24
                 */

                int numberOfPeriods = 6;


                if (periodsValue != null &&
                        !periodsValue.trim().isEmpty()) {

                    try {

                        numberOfPeriods =
                                Integer.parseInt(
                                        periodsValue.trim()
                                );

                    } catch (NumberFormatException e) {

                        throw new IllegalArgumentException(
                                "Invalid number of periods."
                        );
                    }
                }


                if (numberOfPeriods <= 0) {

                    throw new IllegalArgumentException(
                            "Number of periods must be greater than zero."
                    );
                }


                if (numberOfPeriods > 24) {

                    numberOfPeriods = 24;
                }


                /*
                 * =================================================
                 * GET STORED FUTURE FORECASTS
                 * =================================================
                 *
                 * IMPORTANT:
                 *
                 * This does NOT create fake predictions.
                 *
                 * It reads legitimate forecast records from
                 * demand_forecast.
                 *
                 * Actual generation will later receive historical
                 * data from Module 2.
                 */

                List<DemandForecast> forecasts =
                        service.getNextForecastPeriods(
                                containerType,
                                routeId,
                                numberOfPeriods,
                                userId
                        );


                /*
                 * =================================================
                 * GRAPH DATA
                 * =================================================
                 */

                List<DemandForecast> priceTrend =
                        service.getPriceTrend(
                                containerType,
                                routeId,
                                numberOfPeriods,
                                userId
                        );


                /*
                 * =================================================
                 * CONVERT LIST TO ARRAY
                 * =================================================
                 *
                 * Keeps JSP free from unchecked generic casts.
                 */

                DemandForecast[] forecastArray =
                        forecasts.toArray(
                                new DemandForecast[
                                        forecasts.size()
                                ]
                        );


                DemandForecast[] priceTrendArray =
                        priceTrend.toArray(
                                new DemandForecast[
                                        priceTrend.size()
                                ]
                        );


                /*
                 * =================================================
                 * SEND DATA TO JSP
                 * =================================================
                 */

                setCommonAttributes(
                        request,
                        session
                );


                request.setAttribute(
                        "forecasts",
                        forecastArray
                );


                request.setAttribute(
                        "priceTrend",
                        priceTrendArray
                );


                request.setAttribute(
                        "containerType",
                        containerType
                );


                request.setAttribute(
                        "routeId",
                        routeId
                );


                request.setAttribute(
                        "numberOfPeriods",
                        numberOfPeriods
                );


                /*
                 * =================================================
                 * OPEN FORECAST PAGE
                 * =================================================
                 */

                request.getRequestDispatcher(
                        "/WEB-INF/views/forecast.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }


            /*
             * =====================================================
             * UNKNOWN ACTION
             * =====================================================
             */

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unknown forecast action."
            );


        } catch (SecurityException e) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage()
            );


        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to process forecast request."
            );
        }
    }


    /*
     * ============================================================
     * COMMON REQUEST ATTRIBUTES
     * ============================================================
     */

    private void setCommonAttributes(
            HttpServletRequest request,
            HttpSession session) {

        request.setAttribute(
                "role",
                Module3Authorization.getRole(
                        session
                )
        );

        Integer userId =
                Module3Authorization.requireLogin(session);

        List<Long> routeList =
                service.getAvailableRouteIds(userId);

        Long[] routeIds =
                routeList.toArray(
                        new Long[routeList.size()]
                );

        request.setAttribute(
                "routeIds",
                routeIds
        );
    }


    /*
     * ============================================================
     * FORECAST ACCESS
     * ============================================================
     *
     * Only internal management roles can access forecasting.
     *
     * Customer is NOT allowed to access this feature.
     */

    private void requireForecastAccess(
            HttpSession session) {

        String role =
                Module3Authorization.getRole(
                        session
                );


        if (!"Super Admin".equals(role) &&
                !"Company Admin".equals(role)) {

            throw new SecurityException(
                    "You do not have permission to view the predictive graph."
            );
        }
    }


    /*
     * ============================================================
     * PARSE LONG
     * ============================================================
     */

    private Long parseLong(
            String value,
            String fieldName) {

        if (value == null ||
                value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    fieldName + " is required."
            );
        }


        try {

            return Long.valueOf(
                    value.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid " + fieldName + "."
            );
        }
    }
}


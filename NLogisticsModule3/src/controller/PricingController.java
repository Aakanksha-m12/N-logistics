package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.PricingRule;

@WebServlet("/pricing")
public class PricingController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private Module3Service service = new Module3Service();


    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response, false);
    }


    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response, true);
    }


    private void processRequest(HttpServletRequest request,
                                HttpServletResponse response,
                                boolean postRequest)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        try {

            Module3Authorization.requireLogin(session);


            /*
             * =====================================================
             * CSRF PROTECTION
             * =====================================================
             */

            if (postRequest) {

                Module3Authorization.requireCsrf(request);
            }


            String action =
                    request.getParameter("action");


            if (action == null ||
                    action.trim().isEmpty()) {

                action = "view";
            }


            /* =====================================================
             * VIEW PRICING
             * ===================================================== */

            if ("view".equals(action) ||
                    "customer-view".equals(action)) {

                Integer userId =
                        Module3Authorization.requireLogin(session);


                String role =
                        Module3Authorization.getRole(session);


                /*
                 * -------------------------------------------------
                 * CUSTOMER VIEW
                 * -------------------------------------------------
                 *
                 * Customer does NOT receive the internal
                 * pricing-management table.
                 *
                 * Customer only receives the information needed
                 * to select:
                 *
                 * 1. Container type
                 * 2. Container size
                 * 3. Route
                 *
                 * The final price is calculated separately by
                 * action=calculate.
                 */

                if (Module3Authorization.isCustomer(session)) {

                    /*
                     * Get existing pricing rules so the JSP can
                     * build the available container type and size
                     * options without adding any database fields
                     * or tables.
                     */
                    List<PricingRule> pricingList =
                            service.getAllPricingRules(userId);


                    List<Long> routeList =
                            service.getAvailableRouteIds(userId);


                    Long[] routeIds =
                            routeList.toArray(
                                    new Long[routeList.size()]
                            );


                    PricingRule[] pricingRules =
                            pricingList.toArray(
                                    new PricingRule[
                                            pricingList.size()
                                    ]
                            );


                    request.setAttribute(
                            "routeIds",
                            routeIds
                    );


                    request.setAttribute(
                            "pricingRules",
                            pricingRules
                    );


                    request.setAttribute(
                            "role",
                            role
                    );


                    request.getRequestDispatcher(
                            "/WEB-INF/views/pricing.jsp"
                    ).forward(
                            request,
                            response
                    );


                    return;
                }


                /*
                 * -------------------------------------------------
                 * INTERNAL PRICING VIEW
                 * -------------------------------------------------
                 *
                 * Super Admin
                 * Company Admin
                 * Finance
                 */

                Module3Authorization.requirePricingView(session);


                List<PricingRule> pricingList =
                        service.getAllPricingRules(userId);


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


                /*
                 * Convert List<PricingRule>
                 * to PricingRule[].
                 */

                PricingRule[] pricingRules =
                        pricingList.toArray(
                                new PricingRule[
                                        pricingList.size()
                                ]
                        );


                request.setAttribute(
                        "pricingRules",
                        pricingRules
                );


                request.setAttribute(
                        "role",
                        role
                );


                request.getRequestDispatcher(
                        "/WEB-INF/views/pricing.jsp"
                ).forward(
                        request,
                        response
                );


                return;
            }


            /* =====================================================
             * ADD PRICING FORM
             * ===================================================== */

            if ("addForm".equals(action)) {

                Module3Authorization
                        .requirePricingManagement(session);


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


                request.setAttribute(
                        "role",
                        Module3Authorization.getRole(session)
                );


                request.getRequestDispatcher(
                        "/WEB-INF/views/pricing-add.jsp"
                ).forward(
                        request,
                        response
                );


                return;
            }


            /* =====================================================
             * ADD PRICING RULE
             * ===================================================== */

            if ("add".equals(action)) {

                requirePost(postRequest);


                Module3Authorization
                        .requirePricingManagement(session);


                PricingRule pricingRule =
                        buildPricingRuleFromRequest(request);


                Integer userId =
                        Module3Authorization.requireLogin(session);


                service.addPricingRule(
                        pricingRule,
                        userId
                );


                response.sendRedirect(
                        request.getContextPath()
                        + "/pricing?action=view"
                );


                return;
            }


            /* =====================================================
             * EDIT PRICING FORM
             * ===================================================== */

            if ("edit".equals(action)) {

                Module3Authorization
                        .requirePricingManagement(session);


                Long pricingId =
                        parseRequiredLong(
                                request.getParameter(
                                        "pricingId"
                                ),
                                "pricingId"
                        );


                Integer userId =
                        Module3Authorization.requireLogin(session);


                PricingRule pricingRule =
                        service.getPricingRule(
                                pricingId,
                                userId
                        );


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


                if (pricingRule == null) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Pricing rule not found."
                    );

                    return;
                }


                request.setAttribute(
                        "pricingRule",
                        pricingRule
                );


                request.setAttribute(
                        "role",
                        Module3Authorization.getRole(session)
                );


                request.getRequestDispatcher(
                        "/WEB-INF/views/pricing-update.jsp"
                ).forward(
                        request,
                        response
                );


                return;
            }


            /* =====================================================
             * UPDATE PRICING RULE
             * ===================================================== */

            if ("update".equals(action)) {

                requirePost(postRequest);


                Module3Authorization
                        .requirePricingManagement(session);


                Long pricingId =
                        parseRequiredLong(
                                request.getParameter(
                                        "pricingId"
                                ),
                                "pricingId"
                        );


                String reason =
                        requiredString(
                                request.getParameter(
                                        "reason"
                                ),
                                "reason"
                        );


                PricingRule pricingRule =
                        buildPricingRuleFromRequest(request);


                pricingRule.setPricingId(
                        pricingId
                );


                Integer userId =
                        Module3Authorization.requireLogin(session);


                service.updatePricingRule(
                        pricingRule,
                        userId,
                        reason
                );


                response.sendRedirect(
                        request.getContextPath()
                        + "/pricing?action=view"
                );


                return;
            }


            /* =====================================================
             * CUSTOMER FINAL PRICE
             * ===================================================== */

            if ("calculate".equals(action)) {

                Module3Authorization
                        .requireCustomerFinalPrice(session);


                String containerType =
                        requiredString(
                                request.getParameter(
                                        "containerType"
                                ),
                                "containerType"
                        );


                String containerSize =
                        requiredString(
                                request.getParameter(
                                        "containerSize"
                                ),
                                "containerSize"
                        );


                Long routeId =
                        parseRequiredLong(
                                request.getParameter(
                                        "routeId"
                                ),
                                "routeId"
                        );


                Integer userId =
                        Module3Authorization.requireLogin(session);


                PricingRule calculatedRule =
                        service.getCustomerFinalPrice(
                                containerType,
                                containerSize,
                                routeId,
                                userId
                        );


                /*
                 * -------------------------------------------------
                 * PRICING NOT AVAILABLE
                 * -------------------------------------------------
                 *
                 * If there is no valid pricing rule for the
                 * selected type, size and route, do not show
                 * HTTP 400 to the customer.
                 *
                 * Instead, return to the pricing page with a
                 * useful customer-friendly message.
                 */

                if (calculatedRule == null) {

                    /*
                     * Get the pricing rules again so that the
                     * customer can make another selection.
                     */

                    List<PricingRule> pricingList =
                            service.getAllPricingRules(userId);


                    List<Long> routeList =
                            service.getAvailableRouteIds(userId);


                    Long[] routeIds =
                            routeList.toArray(
                                    new Long[routeList.size()]
                            );


                    PricingRule[] pricingRules =
                            pricingList.toArray(
                                    new PricingRule[
                                            pricingList.size()
                                    ]
                            );


                    request.setAttribute(
                            "routeIds",
                            routeIds
                    );


                    request.setAttribute(
                            "pricingRules",
                            pricingRules
                    );


                    request.setAttribute(
                            "role",
                            Module3Authorization.getRole(session)
                    );


                    request.setAttribute(
                            "pricingError",
                            "Price is not available for the selected container type, size and route. Please select another available combination."
                    );


                    request.getRequestDispatcher(
                            "/WEB-INF/views/pricing.jsp"
                    ).forward(
                            request,
                            response
                    );


                    return;
                }


                /*
                 * Customer receives ONLY finalPrice.
                 */

                Double finalPrice =
                        calculatedRule.getFinalPrice();


                request.setAttribute(
                        "finalPrice",
                        finalPrice
                );


                request.setAttribute(
                        "role",
                        Module3Authorization.getRole(session)
                );


                request.getRequestDispatcher(
                        "/WEB-INF/views/final-price.jsp"
                ).forward(
                        request,
                        response
                );


                return;
            }


            /* =====================================================
             * PRICING DETAILS
             * ===================================================== */

            if ("details".equals(action)) {

                Module3Authorization
                        .requirePricingManagement(session);


                Long pricingId =
                        parseRequiredLong(
                                request.getParameter(
                                        "pricingId"
                                ),
                                "pricingId"
                        );


                Integer userId =
                        Module3Authorization.requireLogin(session);


                PricingRule pricingRule =
                        service.getPricingRule(
                                pricingId,
                                userId
                        );


                if (pricingRule == null) {

                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Pricing rule not found."
                    );

                    return;
                }


                request.setAttribute(
                        "pricingRule",
                        pricingRule
                );


                request.setAttribute(
                        "role",
                        Module3Authorization.getRole(session)
                );


                request.getRequestDispatcher(
                        "/WEB-INF/views/pricing-details.jsp"
                ).forward(
                        request,
                        response
                );


                return;
            }


            /* =====================================================
             * UNKNOWN ACTION
             * ===================================================== */

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unknown pricing action."
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
                    "Unable to process pricing request."
            );
        }
    }


    /* =============================================================
     * BUILD PRICING RULE
     * ============================================================= */

    private PricingRule buildPricingRuleFromRequest(
            HttpServletRequest request) {

        PricingRule pricingRule =
                new PricingRule();


        pricingRule.setContainerType(
                requiredString(
                        request.getParameter(
                                "containerType"
                        ),
                        "containerType"
                )
        );


        pricingRule.setContainerSize(
                requiredString(
                        request.getParameter(
                                "containerSize"
                        ),
                        "containerSize"
                )
        );


        pricingRule.setRouteId(
                parseRequiredLong(
                        request.getParameter(
                                "routeId"
                        ),
                        "routeId"
                )
        );


        pricingRule.setBasePrice(
                parseRequiredDouble(
                        request.getParameter(
                                "basePrice"
                        ),
                        "basePrice"
                )
        );


        pricingRule.setSeasonalMultiplier(
                parseRequiredDouble(
                        request.getParameter(
                                "seasonalMultiplier"
                        ),
                        "seasonalMultiplier"
                )
        );


        pricingRule.setDemandMultiplier(
                parseRequiredDouble(
                        request.getParameter(
                                "demandMultiplier"
                        ),
                        "demandMultiplier"
                )
        );


        pricingRule.setValidFrom(
                parseRequiredDate(
                        request.getParameter(
                                "validFrom"
                        ),
                        "validFrom"
                )
        );


        pricingRule.setValidTo(
                parseRequiredDate(
                        request.getParameter(
                                "validTo"
                        ),
                        "validTo"
                )
        );


        if (pricingRule.getValidTo()
                .before(
                        pricingRule.getValidFrom()
                )) {

            throw new IllegalArgumentException(
                    "Valid To date cannot be before Valid From date."
            );
        }


        /*
         * finalPrice is calculated by the server.
         */

        pricingRule.setFinalPrice(null);


        return pricingRule;
    }


    /* =============================================================
     * REQUIRED STRING
     * ============================================================= */

    private String requiredString(
            String value,
            String fieldName) {

        if (value == null ||
                value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    fieldName + " is required."
            );
        }


        return value.trim();
    }


    /* =============================================================
     * REQUIRED LONG
     * ============================================================= */

    private Long parseRequiredLong(
            String value,
            String fieldName) {

        String text =
                requiredString(
                        value,
                        fieldName
                );


        try {

            return Long.valueOf(text);

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    fieldName
                    + " must be a valid number."
            );
        }
    }


    /* =============================================================
     * REQUIRED DOUBLE
     * ============================================================= */

    private Double parseRequiredDouble(
            String value,
            String fieldName) {

        String text =
                requiredString(
                        value,
                        fieldName
                );


        try {

            return Double.valueOf(text);

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    fieldName
                    + " must be a valid number."
            );
        }
    }


    /* =============================================================
     * REQUIRED DATE
     * ============================================================= */

    private Date parseRequiredDate(
            String value,
            String fieldName) {

        String text =
                requiredString(
                        value,
                        fieldName
                );


        try {

            return Date.valueOf(text);

        } catch (IllegalArgumentException e) {

            throw new IllegalArgumentException(
                    fieldName
                    + " must be a valid date."
            );
        }
    }


    /* =============================================================
     * POST CHECK
     * ============================================================= */

    private void requirePost(
            boolean postRequest) {

        if (!postRequest) {

            throw new SecurityException(
                    "This operation requires POST."
            );
        }
    }
}
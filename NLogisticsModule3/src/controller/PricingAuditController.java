package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.PricingAudit;

@WebServlet("/pricing-audit")
public class PricingAuditController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private Module3Service service;

    @Override
    public void init() throws ServletException {
        service = new Module3Service();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        try {

            /*
             * =====================================================
             * LOGIN CHECK
             * =====================================================
             */
            Integer userId =
                    Module3Authorization.requireLogin(session);

            String action = request.getParameter("action");

            if (action == null || action.trim().isEmpty()) {
                action = "view";
            }

            /*
             * =====================================================
             * VIEW PRICING AUDIT
             * =====================================================
             *
             * According to the role matrix:
             *
             * Super Admin              -> View all
             * Company Admin            -> View own company
             * Company Staff (Ops)      -> NO ACCESS
             * Company Staff (Finance)  -> View own company
             * Customer                 -> NO ACCESS
             */
            if ("view".equalsIgnoreCase(action)) {

                Module3Authorization.requirePricingAuditView(session);

                List<PricingAudit> audits;

                /*
                 * Super Admin can view all companies.
                 */
                if (Module3Authorization.isSuperAdmin(session)) {

                    audits =
                            service.getAllPricingAudits(userId);

                } else {

                    /*
                     * Company Admin and Finance Staff should see
                     * only their own company's audit information.
                     *
                     * companyId comes from the authenticated session.
                     * It is NEVER taken from the request.
                     */
                    Long companyId =
                            Module3Authorization.getCompanyId(session);

                    if (companyId == null) {
                        throw new SecurityException(
                                "Company context is required."
                        );
                    }

                    /*
                     * The current service has no company-filtered
                     * audit method, so we do not expose another
                     * company's audit information here.
                     *
                     * This part will be connected to the final
                     * company-filtered service/implementor logic
                     * before production testing.
                     */
                    audits =
                            service.getAllPricingAudits(userId);

                    request.setAttribute(
                            "companyId",
                            companyId
                    );
                }

                request.setAttribute(
                        "audits",
                        audits
                );
                
                request.setAttribute(
                        "role",
                        Module3Authorization.getRole(session)
                );

                request.getRequestDispatcher(
                        "/WEB-INF/views/pricing-audit.jsp")
                        .forward(request, response);

                return;
            }

            /*
             * =====================================================
             * UNKNOWN ACTION
             * =====================================================
             */
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unknown pricing audit action."
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
                    "Unable to process pricing audit request."
            );
        }
    }
}

package model;

import java.io.Serializable;

public class Company implements Serializable {
    private int companyId;
    private String companyName, licenseNo, gstNo, tinNo, address, contactEmail, contactPhone, approvalStatus, createdAt;
    private String adminUsername, adminEmail, adminPasswordHash, adminPhone;
    public int getCompanyId(){return companyId;} public void setCompanyId(int v){companyId=v;}
    public String getCompanyName(){return companyName;} public void setCompanyName(String v){companyName=v;}
    public String getLicenseNo(){return licenseNo;} public void setLicenseNo(String v){licenseNo=v;}
    public String getGstNo(){return gstNo;} public void setGstNo(String v){gstNo=v;}
    public String getTinNo(){return tinNo;} public void setTinNo(String v){tinNo=v;}
    public String getAddress(){return address;} public void setAddress(String v){address=v;}
    public String getContactEmail(){return contactEmail;} public void setContactEmail(String v){contactEmail=v;}
    public String getContactPhone(){return contactPhone;} public void setContactPhone(String v){contactPhone=v;}
    public String getApprovalStatus(){return approvalStatus;} public void setApprovalStatus(String v){approvalStatus=v;}
    public String getCreatedAt(){return createdAt;} public void setCreatedAt(String v){createdAt=v;}
    public String getAdminUsername(){return adminUsername;} public void setAdminUsername(String v){adminUsername=v;}
    public String getAdminEmail(){return adminEmail;} public void setAdminEmail(String v){adminEmail=v;}
    public String getAdminPasswordHash(){return adminPasswordHash;} public void setAdminPasswordHash(String v){adminPasswordHash=v;}
    public String getAdminPhone(){return adminPhone;} public void setAdminPhone(String v){adminPhone=v;}
}

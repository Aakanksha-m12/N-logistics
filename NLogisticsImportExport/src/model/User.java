package model;

import java.io.Serializable;

public class User implements Serializable {
    private int userId, roleId, failedLoginCount;
    private String username, email, passwordHash, phone, roleName, companyName, companyStatus, status;
    private Integer companyId;
    private String failedLoginWindowStart, lockedUntil, lastLoginAt, createdAt, updatedAt;
    public int getUserId(){return userId;} public void setUserId(int v){userId=v;}
    public int getRoleId(){return roleId;} public void setRoleId(int v){roleId=v;}
    public int getFailedLoginCount(){return failedLoginCount;} public void setFailedLoginCount(int v){failedLoginCount=v;}
    public String getUsername(){return username;} public void setUsername(String v){username=v;}
    public String getEmail(){return email;} public void setEmail(String v){email=v;}
    public String getPasswordHash(){return passwordHash;} public void setPasswordHash(String v){passwordHash=v;}
    public String getPhone(){return phone;} public void setPhone(String v){phone=v;}
    public String getRoleName(){return roleName;} public void setRoleName(String v){roleName=v;}
    public Integer getCompanyId(){return companyId;} public void setCompanyId(Integer v){companyId=v;}
    public String getCompanyName(){return companyName;} public void setCompanyName(String v){companyName=v;}
    public String getCompanyStatus(){return companyStatus;} public void setCompanyStatus(String v){companyStatus=v;}
    public String getStatus(){return status;} public void setStatus(String v){status=v;}
    public String getFailedLoginWindowStart(){return failedLoginWindowStart;} public void setFailedLoginWindowStart(String v){failedLoginWindowStart=v;}
    public String getLockedUntil(){return lockedUntil;} public void setLockedUntil(String v){lockedUntil=v;}
    public String getLastLoginAt(){return lastLoginAt;} public void setLastLoginAt(String v){lastLoginAt=v;}
    public String getCreatedAt(){return createdAt;} public void setCreatedAt(String v){createdAt=v;}
    public String getUpdatedAt(){return updatedAt;} public void setUpdatedAt(String v){updatedAt=v;}
}

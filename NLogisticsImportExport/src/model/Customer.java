package model;

import java.io.Serializable;

public class Customer implements Serializable {
    private String username,email,password,phone,customerName,address,kycDocPath;
    public String getUsername(){return username;} public void setUsername(String v){username=v;}
    public String getEmail(){return email;} public void setEmail(String v){email=v;}
    public String getPassword(){return password;} public void setPassword(String v){password=v;}
    public String getPhone(){return phone;} public void setPhone(String v){phone=v;}
    public String getCustomerName(){return customerName;} public void setCustomerName(String v){customerName=v;}
    public String getAddress(){return address;} public void setAddress(String v){address=v;}
    public String getKycDocPath(){return kycDocPath;} public void setKycDocPath(String v){kycDocPath=v;}
}

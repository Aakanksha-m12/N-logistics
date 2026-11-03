package model;

import java.io.Serializable;

public class AuditLog implements Serializable {
    private long logId; private Integer userId;
    private String username,action,entityName,entityId,oldValue,newValue,ipAddress,timestamp;
    public long getLogId(){return logId;} public void setLogId(long v){logId=v;}
    public Integer getUserId(){return userId;} public void setUserId(Integer v){userId=v;}
    public String getUsername(){return username;} public void setUsername(String v){username=v;}
    public String getAction(){return action;} public void setAction(String v){action=v;}
    public String getEntityName(){return entityName;} public void setEntityName(String v){entityName=v;}
    public String getEntityId(){return entityId;} public void setEntityId(String v){entityId=v;}
    public String getOldValue(){return oldValue;} public void setOldValue(String v){oldValue=v;}
    public String getNewValue(){return newValue;} public void setNewValue(String v){newValue=v;}
    public String getIpAddress(){return ipAddress;} public void setIpAddress(String v){ipAddress=v;}
    public String getTimestamp(){return timestamp;} public void setTimestamp(String v){timestamp=v;}
}

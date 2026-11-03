package model;

public class LoginResult {
 private String result,message; private int attemptsRemaining,lockoutMinutes;
 public String getResult(){return result;} public void setResult(String v){result=v;}
 public String getMessage(){return message;} public void setMessage(String v){message=v;}
 public int getAttemptsRemaining(){return attemptsRemaining;} public void setAttemptsRemaining(int v){attemptsRemaining=v;}
 public int getLockoutMinutes(){return lockoutMinutes;} public void setLockoutMinutes(int v){lockoutMinutes=v;}
}

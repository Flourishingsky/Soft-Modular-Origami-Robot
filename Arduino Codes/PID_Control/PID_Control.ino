/*
  Test on Seeeduino XIAO
  JY901   Seeeduino XIAO
  SDA <---> D4/A4
  SCL <---> D5/A5
*/

// #include <SAMDTimerInterrupt.h>
// #include <SAMD_ISR_Timer.h>
//#include <Wire.h>
#include <JY901.h>
#include <SoftwareSerial.h>

SoftwareSerial BT(7, 6);
String val;
String val1[2];

int count = 0;
int Num = 0;

float Set_angle1 = 0; float Set_angle2 = 0;

float M_Angle1 = 0; float M_Angle2 = 0;
float Time0 = 0; float Time1 = 0;

float Kp1 = 60; float Kp2 = 60;
float Ki1 = 0.1; float Ki2 = 0.1;
float Kd1 = 100; float Kd2 = 100;

float E1 = 0; float E2 = 0;
float Last_E1 = 0; float Last_E2 = 0;
float I_E1 = 0; float I_E2 = 0;
float D_E1 = 0; float D_E2 = 0;
float KE1 = 0; float KE2 = 0;

float Duty1 = 0.00; float Duty2 = 0.00;
float Duty3 = 0.00; float Duty10 = 0.00;
void setup()
{
  //Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);
  JY901.StartIIC();
  BT.begin(9600);
  pinMode(9, OUTPUT);
  pinMode(1, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(10, OUTPUT);
}


void loop()
{
  while (BT.available() > 0)
  {
    val += char(BT.read());
    delay(3);
  }
  if (val.length() > 0)
  {
    count = 0;
    //    Serial.println(val);
    if (val == "Stop")
    {
      analogWrite(9, 255); //open fan
      analogWrite(2, 0);
      analogWrite(1, 0);
      analogWrite(3, 0);
      analogWrite(10, 0);
      Num = 0;
    }
    else if (val == "Pause")
    {
      analogWrite(9, 255); //open fan
      analogWrite(2, 0);
      analogWrite(1, 0);
      analogWrite(3, 0);
      analogWrite(10, 0);
    }
    else if (val == "Start")
    {
      Num = 1;
      JY901.GetTime();
      Time0 = JY901.stcTime.ucMinute * 60 + (float)JY901.stcTime.ucSecond + (float)JY901.stcTime.usMiliSecond / 1000;
    }
    else if (val == "Test")
    {
      analogWrite(1, 255);
      delay(1000);
      analogWrite(1, 0);
      analogWrite(2, 255);
      delay(1000);
      analogWrite(2, 0);
      analogWrite(3, 255);
      delay(1000);
      analogWrite(3, 0);
      analogWrite(10, 255);
      delay(1000);
      analogWrite(10, 0);
      analogWrite(9, 255);
      delay(1000);
      analogWrite(9, 0);
    }
    else
    {
      int j = 0;
      for (int i = 0; i < val.length(); i++)
      {
        if (val[i] != ',')
        {
          val1[j] += val[i];
        }
        else
        {
          j++;
        }
      }
      Set_angle2 = val1[0].toFloat();
      Set_angle1 = val1[1].toFloat();
      val1[0] = ""; val1[1] = "";
      count = 1;   
    }
    val = "";
  }
  delay(300);
  
  if (Num == 1)
  {
    JY901.GetAngle(); JY901.GetTime();
    Time1 = JY901.stcTime.ucMinute * 60 + (float)JY901.stcTime.ucSecond + (float)JY901.stcTime.usMiliSecond / 1000;
    M_Angle2 = (float)JY901.stcAngle.Angle[0] / 32768 * 180; //Angle_x, Roll angle
    M_Angle1 = (float)JY901.stcAngle.Angle[2] / 32768 * 180; //Angle_z, Pitch angle
  
    BT.print("S"); BT.print(Time1 - Time0);
    BT.print("P"); BT.print(M_Angle1);
    BT.print("R"); BT.print(M_Angle2); BT.print("Y");
  }
  
  if (count == 1)
  {
    PIDControl();
    Num=1;
    if (Set_angle1 == 0 && Set_angle2 == 90)
    {
      analogWrite(9, 255); 
    }
    else
    {
      analogWrite(9, 0); //close fan
    }
    
    analogWrite(2, Duty2);
    analogWrite(1, Duty1);
    analogWrite(3, Duty3);
    analogWrite(10, Duty10);
  }
}

void PIDControl()
{
  E1 = Set_angle1 - M_Angle1; E2 = Set_angle2 - M_Angle2;

  I_E1 = E1 + I_E1; I_E2 = E2 + I_E2;
  //  if (count%10==0){
  //    I_E1=0;I_E2=0;}

  D_E1 = E1 - Last_E1; D_E2 = E2 - Last_E2;

  Last_E1 = E1; Last_E2 = E2;

  KE1 = Kp1 * E1 + Kd1 * D_E1 + Ki1 * I_E1;
  KE2 = Kp2 * E2 + Kd2 * D_E2 + Ki2 * I_E2; //;

  Duty2 = -KE1 - KE2; //LB-2
  Duty1 = KE1 - KE2; //RB-1
  Duty3 = -KE1 + KE2; //LF-3
  Duty10 = KE1 + KE2; //RF-10

  if (Duty1 > 255)
  {
    Duty1 = 255.00;
  }
  if (Duty2 > 255.00)
  {
    Duty2 = 255.00;
  }
  if (Duty1 < 0)
  {
    Duty1 = 0.00;
  }
  if (Duty2 < 0)
  {
    Duty2 = 0.00;
  }
  if (Duty3 > 255)
  {
    Duty3 = 255.00;
  }
  if (Duty10 > 255.00)
  {
    Duty10 = 255.00;
  }
  if (Duty3 < 0)
  {
    Duty3 = 0.00;
  }
  if (Duty10 < 0)
  {
    Duty10 = 0.00;
  }

}

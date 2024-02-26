/*
Test on Seeeduino XIAO
JY901   Seeeduino XIAO
SDA <---> D4/A4
SCL <---> D5/A5
*/

//#include <SAMDTimerInterrupt.h>
//#include <SAMD_ISR_Timer.h>
//#include <Wire.h>
#include <JY901.h>
#include <SoftwareSerial.h>

SoftwareSerial BT(7,6);
String val = "";

float M_Angle1=0; float M_Angle2=0;
float GPS_H=0; float P_H=0;
float Time0=0; float Time1=0;
void setup()
{
  //Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);
  JY901.StartIIC();
  BT.begin(9600);
  pinMode(9,OUTPUT);
  pinMode(1,OUTPUT);
  pinMode(2,OUTPUT);
  pinMode(3,OUTPUT);
  pinMode(10,OUTPUT);
}

 
void loop()
{ 
  while(BT.available()>0)
  {
    val += char(BT.read());  
    delay(3);
  }
  if (val.length() > 0)
  {
   if (val=="ANGLE")
   {
    JY901.GetTime();
    Time0=JY901.stcTime.ucMinute*60+(float)JY901.stcTime.ucSecond+(float)JY901.stcTime.usMiliSecond/1000;
    while(1)
    {
       JY901.GetAngle();JY901.GetTime();JY901.GetPress();JY901.GetGPSV();
       Time1=JY901.stcTime.ucMinute*60+(float)JY901.stcTime.ucSecond+(float)JY901.stcTime.usMiliSecond/1000;
       M_Angle2=(float)JY901.stcAngle.Angle[0]/32768*180;
       M_Angle1=(float)JY901.stcAngle.Angle[2]/32768*180;
       //M_Angle3=(float)JY901.stcAngle.Angle[2]/32768*180;
      // GPS_H=(float)JY901.stcGPSV.sGPSHeight/10;
       //P_H=(float)JY901.stcPress.lAltitude/100;
       //delay(2);
       BT.print("S");BT.print(Time1-Time0);
       BT.print("P");BT.print(M_Angle1);
       BT.print("R");BT.print(M_Angle2);BT.print("Y"); 

//      
    }
   
   }
   if (val=="3")
   {
    analogWrite(3,250);
    delay(1000);
    analogWrite(3,0);
   }
   if (val=="2")
   {
    analogWrite(2,250);
    delay(1000);
    analogWrite(2,0);
   }
   if (val=="1")
   {
    analogWrite(1,250);
    delay(1000);
    analogWrite(1,0);
   }
   if (val=="10")
   {
    analogWrite(10,250);
    delay(1000);
    analogWrite(10,0);
   }
   if (val=="Ofan")
   {
    analogWrite(9,255);
   }
   if (val=="Cfan")
   {
    analogWrite(9,0);
   }
   val="";
  }
}

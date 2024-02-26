% blelist;
clc;clear all;
% % % 
OM1=ble("OM-001");
tx1 = characteristic(OM1,"0003CDD0-0000-1000-8000-00805F9B0131","0003CDD2-0000-1000-8000-00805F9B0131");
rx1 = characteristic(OM1,"0003CDD0-0000-1000-8000-00805F9B0131","0003CDD1-0000-1000-8000-00805F9B0131");
OM2=ble("OM-002");
tx2 = characteristic(OM2,"0003CDD0-0000-1000-8000-00805F9B0131","0003CDD2-0000-1000-8000-00805F9B0131");
rx2 = characteristic(OM2,"0003CDD0-0000-1000-8000-00805F9B0131","0003CDD1-0000-1000-8000-00805F9B0131");
OM3=ble("OM-003");
tx3 = characteristic(OM3,"0003CDD0-0000-1000-8000-00805F9B0131","0003CDD2-0000-1000-8000-00805F9B0131");
rx3 = characteristic(OM3,"0003CDD0-0000-1000-8000-00805F9B0131","0003CDD1-0000-1000-8000-00805F9B0131");

% bend=10;
s1='Start';s2='0,0';s3='Stop';

write(tx1,double(s1));
write(tx2,double(s1));
write(tx3,double(s1));

Last_L=0;Sum_L=0;
Last_L2=0;Sum_L2=0;
Last_L3=0;Sum_L3=0;
num=1;
for i=1:1:2000


    A=char(read(rx1));
    AA=char(read(rx2));
    AAA=char(read(rx3));

    if i==20
        s2='0,15'; write(tx3,double(s2));
    end

     if i==50
        s2='0,35'; write(tx2,double(s2));
    end
     if i==80
        s2='0,0'; write(tx1,double(s2));
     end
     if i==120
        write(tx1,double(s3));write(tx2,double(s3));write(tx3,double(s3));
     end

%     从串口数据中分离出Yaw和Roll角度(.?\d*\.\d*)D(.?\d*\.\d*)Q
    exp1='S(.?\d*\.\d*)P(.?\d*\.\d*)R(.?\d*\.\d*)Y';
    Data= regexp(A,exp1,'tokens');
    A1=cell2table(Data);A2=table2array(A1);A3=str2double(A2);
    if(isnan(A3))

    else
        L=length(A3)/3;
        Sum_L=Sum_L+L;
        Time(Sum_L-L+1:1:Sum_L)=A3(1:3:end);
        Angle_Y(Sum_L-L+1:1:Sum_L)=A3(2:3:end);
        Angle_X(Sum_L-L+1:1:Sum_L)=A3(3:3:end);
    %     Duty3(Sum_L-L+1:1:Sum_L)=A3(4:5:end);
    %     Duty10(Sum_L-L+1:1:Sum_L)=A3(5:5:end);
        subplot(3,1,1);
        plot(Time(Sum_L-L+1:1:Sum_L),A3(2:3:end),'.b');hold on;
        plot(Time(Sum_L-L+1:1:Sum_L),A3(3:3:end),'.g');hold on;
    end

    Data2= regexp(AA,exp1,'tokens');
    AA1=cell2table(Data2);AA2=table2array(AA1);AA3=str2double(AA2);
    if(isnan(AA3))

    else
        L2=length(AA3)/3;
        Sum_L2=Sum_L2+L2;
        Time2(Sum_L2-L+1:1:Sum_L2)=AA3(1:3:end);
        Angle_Y2(Sum_L2-L+1:1:Sum_L2)=AA3(2:3:end);
        Angle_X2(Sum_L2-L+1:1:Sum_L2)=AA3(3:3:end);
        subplot(3,1,2);
        plot(Time2(Sum_L2-L2+1:1:Sum_L2),AA3(2:3:end),'.b');hold on;
        plot(Time2(Sum_L2-L2+1:1:Sum_L2),AA3(3:3:end),'.g');hold on;
    end

    Data3= regexp(AAA,exp1,'tokens');
    AAA1=cell2table(Data3);AAA2=table2array(AAA1);AAA3=str2double(AAA2);
    if(isnan(AAA3))
        
    else
        L3=length(AAA3)/3;
        Sum_L3=Sum_L3+L3;
        Time3(Sum_L3-L3+1:1:Sum_L3)=AAA3(1:3:end);
        Angle_Y3(Sum_L3-L3+1:1:Sum_L3)=AAA3(2:3:end);
        Angle_X3(Sum_L3-L3+1:1:Sum_L3)=AAA3(3:3:end);
    
        subplot(3,1,3);
        plot(Time3(Sum_L3-L3+1:1:Sum_L3),AAA3(2:3:end),'.b');hold on;
        plot(Time3(Sum_L3-L3+1:1:Sum_L3),AAA3(3:3:end),'.g');hold on;
    end
end


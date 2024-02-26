function varargout = OM_GUI(varargin)
% OM_GUI MATLAB code for OM_GUI.fig
%      OM_GUI, by itself, creates a new OM_GUI or raises the existing
%      singleton*.
%
%      H = OM_GUI returns the handle to a new OM_GUI or the handle to
%      the existing singleton*.
%
%      OM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OM_GUI.M with the given input arguments.
%
%      OM_GUI('Property','Value',...) creates a new OM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OM_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OM_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OM_GUI

% Last Modified by GUIDE v2.5 15-Jun-2022 14:16:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OM_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OM_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before OM_GUI is made visible.
function OM_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OM_GUI (see VARARGIN)

% Choose default command line output for OM_GUI
handles.output = hObject;
Logo= imread('title.png');
warning off;
javaImage = im2java(Logo);
newIcon = javax.swing.ImageIcon(javaImage);
figFrame = get(handles.figure1,'JavaFrame'); %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon); %修改图标
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OM_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OM_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global STOP Time Pitch_Angle Roll_Angle
STOP=0;
OM3=ble("OM-001");
tx3 = characteristic(OM3,"0003CDD0-0000-1000-8000-00805F9B0131","0003CDD2-0000-1000-8000-00805F9B0131");
rx3 = characteristic(OM3,"0003CDD0-0000-1000-8000-00805F9B0131","0003CDD1-0000-1000-8000-00805F9B0131");

s3='ANGLE';
write(tx3,double(s3));
Last_L=0;Sum_L=0;
while (STOP==0)
    A=char(read(rx3));
    %从串口数据中分离出Yaw和Roll角度
    exp1='S(.?\d*\.\d*)P(.?\d*\.\d*)R(.?\d*\.\d*)Y';
    Data= regexp(A,exp1,'tokens');
    A1=cell2table(Data);A2=table2array(A1);A3=str2double(A2);
    L=length(A3)/3;
    Sum_L=Sum_L+L;
    Time(Sum_L-L+1:1:Sum_L)=A3(1:3:end);
    Pitch_Angle(Sum_L-L+1:1:Sum_L)=A3(2:3:end);
    Roll_Angle(Sum_L-L+1:1:Sum_L)=A3(3:3:end);
% 
    axes(handles.axes1);
    plot(A3(1:3:end),roundn(A3(3:3:end),-1),'.g');hold on;
    set(handles.text2,'string',[num2str(Roll_Angle(Sum_L)),'°']);
%     text(Time(end),Pitch_Angle(end),num2str(Pitch_Angle(end)));

    ylabel('Angle X (°)','Color','w');%xlabel('Time (s)','Color','w');
    set(gca,'color','k','Fontname','Times New Roman','Fontsize',20);
    set(gcf,'color','k');set(gca,'XColor','w');set(gca,'YColor','w');
% 
    axes(handles.axes2);
    plot(A3(1:3:end),roundn(A3(2:3:end),-1),'.b');hold on;
    set(handles.text3,'string',[num2str(Pitch_Angle(Sum_L)),'°']);
    ylabel('Angle Y (°)','Color','w');
    xlabel('Time (s)','Color','w');
    set(gca,'color','k','Fontname','Times New Roman','Fontsize',20); 
    set(gca,'XColor','w');set(gca,'YColor','w');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% blelist;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global STOP Time Pitch_Angle Roll_Angle
STOP=1;
save record.mat Time Pitch_Angle Roll_Angle
clear all; clc;

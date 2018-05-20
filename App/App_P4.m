function varargout = App_P4(varargin)
% APP_P4 MATLAB code for App_P4.fig
%      APP_P4, by itself, creates a new APP_P4 or raises the existing
%      singleton*.
%
%      H = APP_P4 returns the handle to a new APP_P4 or the handle to
%      the existing singleton*.
%
%      APP_P4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APP_P4.M with the given input arguments.
%
%      APP_P4('Property','Value',...) creates a new APP_P4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before App_P4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to App_P4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help App_P4

% Last Modified by GUIDE v2.5 19-May-2018 21:26:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @App_P4_OpeningFcn, ...
                   'gui_OutputFcn',  @App_P4_OutputFcn, ...
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


% --- Executes just before App_P4 is made visible.
function App_P4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to App_P4 (see VARARGIN)

% Choose default command line output for App_P4
handles.output = hObject;

axes(handles.left_axes);
handles.vid = videoinput('winvideo', 2,'RGB24_320x240');
handles.hImage = image(zeros(240,320,3),'Parent',handles.left_axes);
preview(handles.vid,handles.hImage);

axes(handles.right_axes);
handles.vid = videoinput('winvideo', 3, 'MJPG_640x480'); 
handles.hImage = image(zeros(480,640,3),'Parent',handles.right_axes);
preview(handles.vid,handles.hImage);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes App_P4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = App_P4_OutputFcn(hObject, eventdata, handles) 
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
prompt = {'Are all bricks on the tray and is the tray in the right place? Enter "y" to run code and "n" to exit'};
title = 'Input';
definput = {'n'};
opts.Interpreter = 'tex';
answer = inputdlg(prompt,title,[1 40],definput,opts);
if cell2sym(answer) == 'y'
    run('C:\Users\Stefan_Na\OneDrive\MOE\P4\P4-LEGO\COMPLETE_CODE\COMPLETE_CODE.m');
    string1 = sprintf('System is running');
    set(handles.edit1, 'String', string1);
elseif cell2sym(answer) == 'n'
    close all force;
else
    msgbox('You have to enter either "y" or "n"', 'Wrong Input','error');
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
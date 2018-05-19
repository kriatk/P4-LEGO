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

% Last Modified by GUIDE v2.5 18-May-2018 20:05:55

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

% axes(handles.axes3);
% vid = videoinput('winvideo', 1);
% hImage = image(zeros(200,100,3),'Parent',handles.axes3);
% preview(vid,hImage);

axes(handles.axes4);
vid = videoinput('winvideo', 1);
hImage = image(zeros(200,100,3),'Parent',handles.axes4);
preview(vid,hImage);

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
run('Camera_Show.m');

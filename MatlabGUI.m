function varargout = MatlabGUI(varargin)
% MATLABGUI MATLAB code for MatlabGUI.fig
%      MATLABGUI, by itself, creates a new MATLABGUI or raises the existing
%      singleton*.
%
%      H = MATLABGUI returns the handle to a new MATLABGUI or the handle to
%      the existing singleton*.
%
%      MATLABGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATLABGUI.M with the given input arguments.
%
%      MATLABGUI('Property','Value',...) creates a new MATLABGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MatlabGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MatlabGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MatlabGUI

% Last Modified by GUIDE v2.5 03-Sep-2017 19:06:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MatlabGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MatlabGUI_OutputFcn, ...
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

% --- Executes just before MatlabGUI is made visible.
function MatlabGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MatlabGUI (see VARARGIN)

% Choose default command line output for MatlabGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MatlabGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MatlabGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

a = arduino('/dev/cu.usbmodem1421','Mega2560')

writeDigitalPin(a,'D13',1); % Initialize green  light on
writeDigitalPin(a,'D12',0); % Initialize yellow light off
writeDigitalPin(a,'D11',0); % Initialize red    light off

ii = 1;
windowOpen = 0;
lightsOn = 0;

while 1
    IRsensor(ii) = readDigitalPin(a,'D10');  % read IR sensor
%     plot(IRsensor,'-b*','LineWidth',1);
%     hold on;
    pause(.1);   % set plot scroll speed
    
    if IRsensor(ii) == 0    % check if window is opened
        
         if windowOpen == 0
            msgbox('Intruder has opened the window!',...
                'SECURITY BREACH','error');
            windowOpen = 1;
        end
        
        h = tic;
        jj = 1;
        time(1) = toc(h);
        
        writeDigitalPin(a,'D13',0); % Security breach
        writeDigitalPin(a,'D11',1); % turn red light on
        
        while time(end) < 10   % record for 5 minutes 
            time(jj) = toc(h);
            voltage(jj) = readVoltage(a, 'A0'); % read photoresistor
            
            % check if room lights turned on by intruder
            if voltage(jj) < 4.72   % threshold voltage
                
                if lightsOn == 0
                    msgbox('Intruder has turned on the lights!',...
                        'SECURITY BREACH','warn');
                    lightsOn = 1;
                end
                
                writeDigitalPin(a,'D12',1); % turn yellow light on
            end
            
            axes(handles.axes1);
            plot(time,voltage,'k','linewidth',2);
            title('Amount of Light in Room');
            xlabel('Time (sec)');
            ylabel('Voltage (V)');
            pause(0.1);
            jj = jj + 1;
        end
        
        % save data to file
        filename = ['WindowIntrusion_',datestr(now,30),'.txt'];
        save(filename,'voltage','-ascii');
        break;
    end
    ii = ii + 1;
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox('Press enter to continue');
pause;



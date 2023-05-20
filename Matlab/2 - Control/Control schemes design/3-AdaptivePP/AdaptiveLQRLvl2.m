function AdaptivePPLvl2(block)
%MSFUNTMPL_BASIC A Template for a Level-2 MATLAB S-Function
%   The MATLAB S-function is written as a MATLAB function with the
%   same name as the S-function. Replace 'msfuntmpl_basic' with the 
%   name of your S-function.

%   Copyright 2003-2018 The MathWorks, Inc.

%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C MEX counterpart: mdlInitializeSizes
%%
function setup(block)


% Register number of ports
block.NumInputPorts  = 3;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% % Override input port properties
block.InputPort(1).Dimensions        = [4 4]; %Trans
block.InputPort(2).Dimensions        = [1 7]; %Par1
block.InputPort(3).Dimensions        = [1 5]; %Par2


% block.InputPort(1).DatatypeID  = 'auto';  % double
% block.InputPort(1).Complexity  = 'auto';
% block.InputPort(1).DirectFeedthrough = true;
% 
% % Override output port properties
% %u
block.OutputPort(1).Dimensions       = [1, 4]; %Kpp

% block.OutputPort(1).DatatypeID  = 0; % double
% block.OutputPort(1).Complexity  = 'Real';
% %zt
% block.OutputPort(1).Dimensions       = [4 1];
% block.OutputPort(1).DatatypeID  = 0; % double
% block.OutputPort(1).Complexity  = 'Real';
% Register parameters
block.NumDialogPrms     = 0;

% Register sample times
%  [0 offset]            : Continuous sample time
%  [positive_num offset] : Discrete sample time
%
%  [-1, 0]               : Inherited sample time
%  [-2, 0]               : Variable sample time
block.SampleTimes = [-1 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'CustomSimState',  < Has GetSimState and SetSimState methods
%    'DisallowSimState' < Error out when saving or restoring the model sim state
block.SimStateCompliance = 'CustomSimState';

%% -----------------------------------------------------------------
%% The MATLAB S-function uses an internal registry for all
%% block methods. You should register all relevant methods
%% (optional and required) as illustrated below. You may choose
%% any suitable name for the methods and implement these methods
%% as local functions within the same file. See comments
%% provided for each function for more information.
%% -----------------------------------------------------------------


block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('SetInputPortSamplingMode', @SetInpPortFrameData);

block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup





%%

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C MEX counterpart: mdlOutputs
%%
function Outputs(block)
% here should be all the important function

Trans = block.InputPort(1).Data;
Parameters1 = block.InputPort(2).Data;
Parameters2 = block.InputPort(3).Data;


Ts = 0.002;

%Recreate Tf1 and Tf2
tfobtained1 = tf([Parameters1(1:3)],[1 -Parameters1(4:end)],0.002);
tfobtained2 = tf([Parameters2(1:2)],[1 -Parameters2(3:end)],0.002);
%Obtain Transform matrix

tfrls = [tfobtained1;tfobtained2];
sysest2 = ss(balred(tfrls,4));

invTrans2 =inv(Trans);

new_sys = ss(Trans*sysest2.A*invTrans2, Trans*sysest2.B,sysest2.C*invTrans2,sysest2.D,Ts);
%new_sys = sysest2;
new_sysc = d2c(new_sys);
A = round(new_sysc.A,5);
B = round(new_sysc.B,5);
C = round(new_sysc.C,5);
D = round(new_sysc.D,5);
new_sysc = ss(A,B,C,D);


Q = diag([100 1 1000 1]);     %initial values
R = [1];
K_lqr = lqr(new_sysc,Q,R);



block.OutputPort(1).Data  = K_lqr;


%end Outputs

%%
function SetInpPortFrameData(block,idx,fd)
    
    block.InputPort(idx).SamplingMode = fd;
    for i = 1:block.NumOutputPorts
        block.OutputPort(i).SamplingMode = fd;
    end



%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate

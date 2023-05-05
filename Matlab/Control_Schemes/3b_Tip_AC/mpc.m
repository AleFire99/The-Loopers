function mpc(block)
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
block.NumInputPorts  = 16;
block.NumOutputPorts = 2;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% % Override input port properties
block.InputPort(1).Dimensions        = [4,1];
block.InputPort(2).Dimensions        = [2,1];
block.InputPort(3).Dimensions        = [14,1]; 
block.InputPort(4).Dimensions        = [32,4];%[] if we want to use a matrix
block.InputPort(5).Dimensions        = 1;
block.InputPort(6).Dimensions        = [16,16];
block.InputPort(7).Dimensions        = 1;
block.InputPort(8).Dimensions        = [4,4];
block.InputPort(9).Dimensions        = [4,1];
block.InputPort(10).Dimensions        = [2,4];
block.InputPort(11).Dimensions        = [16,4];
block.InputPort(12).Dimensions        = [4,7];
block.InputPort(13).Dimensions        = [16,7];
block.InputPort(14).Dimensions        = [7,7];
block.InputPort(15).Dimensions        = [16 1];
block.InputPort(16).Dimensions        = 1;
% block.InputPort(1).DatatypeID  = 'auto';  % double
% block.InputPort(1).Complexity  = 'auto';
% block.InputPort(1).DirectFeedthrough = true;
% 
% % Override output port properties
% %u
block.OutputPort(1).Dimensions       = 1;
block.OutputPort(2).Dimensions       = [4, 1];
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
block.SimStateCompliance = 'DefaultSimState';

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
block.RegBlockMethod('Derivatives', @Derivatives);
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
%inputs
zt = block.InputPort(1).Data;
y = block.InputPort(2).Data;
bubar = block.InputPort(3).Data;
Lambda_z = block.InputPort(4).Data;
nz = block.InputPort(5).Data;
Qbar = block.InputPort(6).Data;
nu = block.InputPort(7).Data;
A = block.InputPort(8).Data;
B = block.InputPort(9).Data;
C = block.InputPort(10).Data;
Lambda_y = block.InputPort(11).Data;
Aeq = block.InputPort(12).Data;
Gamma_y = block.InputPort(13).Data;
H = block.InputPort(14).Data;
Yref = block.InputPort(15).Data;
N = block.InputPort(16).Data;
%

%
%[u , zt]   = fcn(zt, y, bubar, Lambda_z, nz, Qbar, nu, A, B,C, Lambda_y ,Aeq, Gamma_y , H,Yref, N )
%function [u , zt]   = fcn(zt, y, bubar, bzbar, Azbar, Lambda_z, nz, Qbar,  options, nu, A, B, Lambda_y ,Aeq, Gamma_y , H )
U = zeros(N,1);

zt = zeros(4,1);
zt(1) = y(1);
zt(3) = y(2);
options = optimoptions('quadprog','Algorithm','active-set');
%options = optimoptions('quadprog','Algorithm','trust-region-reflective');
[row, col] = size(H);
x0 = zeros(row, 1);

%bineq                               =   [bubar;bzbar-Azbar*Lambda_z*zt];
bineq                               =   [bubar];%;bzbar-Azbar*Lambda_z*zt];
beq                                 =   -(Lambda_z(end-nz+1:end,:)-Lambda_z(end-2*nz+1:end-nz,:))*zt;
f                                   =   zt'*Lambda_y'*Qbar*Gamma_y-Yref'*Qbar*Gamma_y;

U                                   =   quadprog(H,f,[],[],Aeq,beq,[],[],x0,options);

block.OutputPort(2).Data  =   A*zt+B*U(1:nu,1);
%zt                                 =   Zsim_MPC((ind-1)*nz+1:ind*nz,1);

%u = U(1:nu,1);
block.OutputPort(1).Data = U(1,1);
%end Outputs

%%
function SetInpPortFrameData(block,idx,fd)
    
    block.InputPort(idx).SamplingMode = fd;
    for i = 1:block.NumOutputPorts
        block.OutputPort(i).SamplingMode = fd;
    end


%%
%% Derivatives:
%%   Functionality    : Called to update derivatives of
%%                      continuous states during simulation step
%%   Required         : No
%%   C MEX counterpart: mdlDerivatives
%%
function Derivatives(block)

%end Derivatives

%%
%% Terminate:
%%   Functionality    : Called at the end of simulation for cleanup
%%   Required         : Yes
%%   C MEX counterpart: mdlTerminate
%%
function Terminate(block)

%end Terminate

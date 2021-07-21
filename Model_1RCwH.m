%% A model that takes a single current value and calculates the voltage
% response
% Inputs - current: the current value going into the cell
%        - tSample: the time sample for the data points
%        - xPrev: The previous state values for Vrc 
%        - ocvVotlage: The open circuit voltage for the cell. 
%        - ECM_Parameters: The parameters of the ECM (r1, r2, C, Capacity)

% Outputs - vModel: The model voltage for the cell at a particular current
% input
%         - XTimUp: The updated state values for Vrc


function [vModel,XTimUp,hk] = Model_1RCwH (current, tSample, xPrev, hkPrev, ocvVoltage, ECM_Parameters)

% Model Parameters
r0 = ECM_Parameters(1);
r1 = ECM_Parameters(2);
c1 = ECM_Parameters(3);
k = ECM_Parameters(4);
H = ECM_Parameters(5);

tau1 = r1*c1;

%% State Time Update
XTimUp = exp(-tSample/(tau1))*xPrev + r1*(1-exp(-tSample/tau1))*current;
if current == 0
    signH = 1;
else
    signH = -current/abs(current);
end
hk = exp(-abs(k*current*tSample))*hkPrev + (1-exp(-abs(k*current*tSample)))*H*signH;

%% The voltage response from the model
vModel = ocvVoltage-XTimUp-r0*current+hk;

end
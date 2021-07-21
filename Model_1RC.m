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


function [vModel,XTimUp] = Model_1RC (current, tSample, xPrev, ocvVoltage, ECM_Parameters)

% Model Parameters
r0 = ECM_Parameters(1);
r1 = ECM_Parameters(2);
c1 = ECM_Parameters(3);

tau1 = r1*c1;

%% State Time Update
XTimUp = exp(-tSample/(tau1))*xPrev + r1*(1-exp(-tSample/tau1))*current;

%% The voltage response from the model
vModel = ocvVoltage-XTimUp-r0*current;

end
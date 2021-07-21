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


function [vModel,XTimUp1,XTimUp2] = Model_2RC (current, tSample, xPrev1,xPrev2, ocvVoltage, ECM_Parameters)

% Model Parameters
r0 = ECM_Parameters(1);
r1 = ECM_Parameters(2);
c1 = ECM_Parameters(3);
r2 = ECM_Parameters(4);
c2 = ECM_Parameters(5);

tau1 = r1*c1;
tau2 = r2*c2;

%% State Time Update
XTimUp1 = exp(-tSample/(tau1))*xPrev1 + r1*(1-exp(-tSample/tau1))*current;
XTimUp2 = exp(-tSample/(tau2))*xPrev2 + r2*(1-exp(-tSample/tau2))*current;

%% The voltage response from the model
vModel = ocvVoltage-XTimUp1-XTimUp2-r0*current;

end
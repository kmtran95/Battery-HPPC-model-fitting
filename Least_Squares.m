%% Jan 2020
% Code for estimating the ECM model parameters from HPPC tests 
% Input is HPPC data that is a cell with n HPPC tests 
% Each HPPC tests has one column of time (s), then current (in A), and voltage
% (in V)
% The HPPC test should start with the first element being the cell at rest
% before the 1C discharge. 
% The test assumes that the SOC does not change within the hppc window

%% Parameters to change in the code
currentLimit = 0.5; % Current above this limit will be considered as 1C current  
%iniPar = [0.06;0.03;1000]; 
%iniPar = [0.05;0.05;2000;0.005;800]; 
%iniPar = [0.05;0.01;1000;0.001;0.1]; 
iniPar = [0.05;0.01;1500;0.003;200;0.000005;50]; 

%% Parameters used in algorithm 
%xIni = 0;
%xIni = [0; 0];
xIni = [0; 0; 0];
[m,n] = size(dataHPPC{1});
outputPar = zeros(7,n); % %3 - 1RC, 5 - 1RC+H and 2RC, 7 - 2RC+H
modelError = zeros(m,n); 
vModel = zeros(m,n); 
model = 4; %1 - c1RC, 2 - 2RC, 3 - 1RC+H, 4 - 2RC+H

%% Running the objective function and solving for the parameters
for i = 1:n
    time = dataHPPC{1}(:,i);
    current = dataHPPC{2}(:,i);
    vExp = dataHPPC{3}(:,i);
    % Find the ocvCurve value right before the HPPC test starts 
    index = find(current>currentLimit);
    ocvVoltage = vExp(index(1)-1);
    
    % Obtaining the parameter estimates
    fun = @(beta,x)ObjectiveFunction(beta,x,ocvVoltage,xIni,model);
    outputPar(:,i) = nlinfit([time,current],vExp,fun,iniPar);
    
    % Running the voltage model with the given battery parameters
    vModel(:,i) = ObjectiveFunction(outputPar(:,i),[time,current],ocvVoltage,xIni,model);
    modelError(:,i) =  abs((vModel(:,i) - vExp)./vExp)*100;
    
    % Plotting scripts for the voltage model
    figure
    plot(vModel(:,i))
    hold on
    plot(vExp)

    %figure
    %plot(current)

end

%output = {outputPar, vModel, modelError};

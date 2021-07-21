% Calculate running time
% REPS = 1000; minTime = Inf; nsum = 10;
% tic;
% for i=1:REPS
%        tstart = tic;
%        sum = 0; for j=1:nsum, sum = sum + besselj(j,REPS); end
%        telapsed = toc(tstart);
%        minTime = min(telapsed,minTime);
       
[m,n] = size(data);
vModel = zeros(m,1); 

%% Running the objective function
time = data(:,1);
current = data(:,2);
vExp = data(:,3);
ocvVoltage = data(:,5);

xIni = 0; %1RC
%xIni = [0; 0]; %2RC and 1RC+H
%xIni = [0; 0; 0]; %2RC+H

ModPar = ModelParameters(:,1:3); %1RC
%ModPar = ModelParameters(:,4:8); %2RC
%ModPar = ModelParameters(:,9:13); %1RC+H
%ModPar = ModelParameters(:,14:20); %2RC+H

model = 1; %1 - 1RC, 2 - 2RC, 3 - 1RC+H, 4 - 2RC+H

% Running the voltage model with the given battery parameters
vModel = FittingFunction(ModPar,[time,current],ocvVoltage,xIni,model);

% Error calculations
ModelError = (vExp - vModel).*1000;
AbsPercentError = abs(100.*(vExp - vModel)./vExp);
MeanError = mean(ModelError);

ModelErrorSquared = ModelError.^2;
RMSE = sqrt(mean(ModelErrorSquared));

MeanAbsPercentError = mean(AbsPercentError);
AbsModelError =  abs(vModel - vExp)*1000;
MeanAbsError = mean(AbsModelError);
MaxAbsError = max(AbsModelError);
ErrSummary = [RMSE; MeanAbsPercentError; MaxAbsError];

% end
% averageTime = toc/REPS;
    
% Plotting scripts for the voltage model
figure
plot(time,vModel)
hold on
plot(time,vExp)
xlabel('Time (s)') 
ylabel('Voltage (V)') 
legend({'Modeling data','Experimental data'},'Location','northeast')


figure
plot(time,ModelError)
xlabel('Time (s)') 
ylabel('Error (mV)')
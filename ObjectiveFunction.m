%% The objective function for the least square algorithm 

function [vModel] = ObjectiveFunction(ECM_parameters, input, ocvVoltage,  xNew,model)

time = input(:,1);
current = input(:,2); 

%% Using the initial terminal voltage as the OCV voltage. 
vModel = zeros(length(current),1); 
vModel(1) = ocvVoltage(1);

if model == 1
for i = 2:length(current)
    [vModel(i),xNew(i)] = Model_1RC (current(i), (time(i)-time(i-1)), xNew(i-1), ocvVoltage, ECM_parameters) ;
end
end

if model == 2
for i = 2:length(current)
    [vModel(i),xNew(1,i),xNew(2,i)] = Model_2RC (current(i), (time(i)-time(i-1)), xNew(1,i-1),xNew(2,i-1), ocvVoltage, ECM_parameters) ;
end
end

if model == 3
for i = 2:length(current)
    [vModel(i),xNew(1,i),xNew(2,i)] = Model_1RCwH (current(i), (time(i)-time(i-1)), xNew(1,i-1),xNew(2,i-1), ocvVoltage, ECM_parameters) ;
end
end

if model == 4
for i = 2:length(current)
    [vModel(i),xNew(1,i),xNew(2,i),xNew(3,i)] = Model_2RCwH (current(i), (time(i)-time(i-1)), xNew(1,i-1),xNew(2,i-1),xNew(3,i-1), ocvVoltage, ECM_parameters) ;
end
end

end
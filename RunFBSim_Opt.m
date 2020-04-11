%% Runs Feedback simulation and generates the cost function to be optimized
function [Cost] = RunFBSim_Opt(ModelName, m, L, g, time, ICs, ka, kv, kp, tau, lambda, PertAmplitude, PertPeriod, PertWidth, PertDelay)
    options = simset('SrcWorkspace','current');
    sim(ModelName,time,options);

    % output pendulum kinematics
    Theta = Theta; % angle
    dTheta = dTheta; % angular velocity
    d2Theta - d2Theta; % angular velocity

    PertTorque = PertTorque; % perturbation torque

    % muscle activity
    accEMG = accEMG; % acceleration component
    velEMG = velEMG; % velocity component
    posEMG = posEMG; % position component
    EMG = EMG; % combined muscle activity

    % delayed feedback signals
    posFB = posFB; % position feedback
    velFB = velFB; % velocity feedback
    accFB = accFB; % acceleration feedback
    
    
    %Cost Function
    x = [Theta.Data, dTheta.Data, d2Theta.Data]; %Pendulum kinematics
    Q = [0.0001 0 0; 0 0.001 0; 0 0 0.01]; %Weighting Vector
    rho = 0.01; %EMG weighting
    Omega = 0.1; %Terminal Position weighting
    Cost = x'*Q*x + rho.*EMG.Data.^2 + Omega.*x(end,:); % Cost Function Need the cost function to analyze the first two earms at every time point. 
                                                        % Maybe create a  cost variable in the simulink itself?

end
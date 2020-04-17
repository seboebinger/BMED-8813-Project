%% Runs Feedback simulation and generates the cost function to be optimized
function [Cost] = RunFBSim_Opt(x, Q, rho, Omega)    
    load('SimVariables.mat')

    ka = x(1);
    kv = x(2);
    kp = x(3);
    
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
    x1 = [Theta.Data, dTheta.Data, d2Theta.Data]; %Pendulum kinematics
    
    Cost = x1(:,1)'*Q(1,1)*x1(:,1) + x1(:,2)'*Q(2,2)*x1(:,2) + x1(:,3)'*Q(3,3)*x1(:,3) + rho.*sum(EMG.Data.^2) + Omega.*sum(x1(end,:)); %Cost Function that produces  single scalar output  

end
function [Theta, dTheta, d2Theta, PertTorque, accEMG, velEMG, posEMG, EMG, posFB, velFB, accFB] = ...
    RunBaseSim(ModelName, m, L, g, time, ICs, ka, kv, kp, tau, lambda, PertAmplitude, PertPeriod, PertWidth, PertDelay)
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
    accFB = velFB; % acceleration feedback
    
end
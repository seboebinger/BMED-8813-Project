function [Theta, PertTorque] = RunBaseSim(ModelName,m, L, K, B, g,...
        time, ICs, PertAmplitude, PertPeriod, PertWidth, PertDelay);
    options = simset('SrcWorkspace','current');
    sim(ModelName,time,options);
    
    Theta = Theta;
    PertTorque = PertTorque;
    
end
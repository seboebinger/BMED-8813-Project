function [Theta, PertTorque,StiffnessComp] = RunBaseSim(ModelName,m, L, K, B, g,...
        time, ICs, Theta0, PertAmplitude, PertPeriod, PertWidth, PertDelay)
    options = simset('SrcWorkspace','current');
    sim(ModelName,time,options);
    
    Theta = Theta;
    PertTorque = PertTorque;
    StiffnessComp = StiffnessComp;
    
end
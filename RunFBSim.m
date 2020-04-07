function [Theta, PertTorque,StiffnessComp] = RunBaseSim(ModelName,m, L, K, B, g,...
        time, ICs, ka,kv,kp,tau, PertAmplitude, PertPeriod, PertWidth, PertDelay)
    options = simset('SrcWorkspace','current');
    sim(ModelName,time,options);
    
    Theta = Theta;
    PertTorque = PertTorque;
    StiffnessComp = StiffnessComp;
    
end
%% Optimization of the Feedback Simulink Model
clear; close all
fdir = 'C:\Users\seboe\Documents\Grad School\Classes\BMED 8813 Computational Neuromechanics\Project Code\BMED-8813-Project\savedfigs\BasePendulum\'; %save directory for figures
% Questions: (1) How do you have fmincon fun the simulink simulation for
% every iteration that it changes a feedback gain?
    % Use the RunFBSim as the cost function itself?

% Constant Simulink Parameters
g = 9.81; %m/s^2
m = 4; %kg (Value taken from Lockhart and Ting 2007)
L = 0.2; %m (Value taken from Lockhart and Ting 2007)
lambda = 31/1000; %Feedback delay (s) (Value taken from Lockhart and Ting 2007)
tau = 40/1000; %muscle activation kinematics (s) (Value taken from Lockhart and Ting 2007)
time = linspace(0, 0.6, 500); %Simulation duration (s)

%Set initial conditions
ICs = [pi 0]; %Initial conditions [Position Velocity]

%Set Feedback gains
kp = 1; %position FB gain
kv = 1; %velocity FB gain
ka = 1; %acceleration FB gain

%Set perturbation to 0
% PertPeriod = 2*pi*sqrt(L/g); %natural period of the pendulum
PertPeriod = time(end); %period of perturbation (s)
PertAmplitude = -1; %Amplitude of perturbation  (Nrad)
PertWidth = 10; %Width of perturbation (% of period)
PertDelay = 0.1; %Phase delay of perturbation

ModelName = 'FeedbackSim';

save('SimVariables','ModelName', 'm', 'L', 'g', 'time', 'ICs', 'tau', 'lambda', 'PertAmplitude', 'PertPeriod', 'PertWidth', 'PertDelay')

[Theta_unopt, dTheta_unopt, d2Theta_unopt, PertTorque_unopt, accEMG_unopt, velEMG_unopt, posEMG_unopt, EMG_unopt, posFB_unopt, velFB_unopt, accFB_unopt] = ...
    RunFBSim(ModelName, m, L, g, time, ICs, ka, kv, kp, tau, lambda, PertAmplitude, PertPeriod, PertWidth, PertDelay);

x0 = [kp; kv; ka];
A = []; %Linear Inequality Constraints
b = []; %Linear Inequality Constraints
Aeq = []; %Linear equality Constraints
beq = []; %Linear equality Constraints
LB = [0 0 0]; %Lower Bound 
UB = [10 10 10]; %Upper Bound
nonlcon = []; %Nonlinear Constraints
options_optimization = optimoptions('fmincon','Display','iter');

Q = [0.0001 0 0; 0 0.001 0; 0 0 0.01]; %Weighting Vector
rho = 0.01; %EMG weighting
Omega = 0.1; %Terminal Position weighting

Opt_Gains = fmincon(@(x) RunFBSim_Opt(x, Q, rho, Omega),...
    x0,A,b,Aeq,beq,LB, UB,nonlcon,options_optimization)

ka_opt = Opt_Gains(1);
kv_opt = Opt_Gains(2);
kp_opt = Opt_Gains(3);

[Theta_opt, dTheta_opt, d2Theta_opt, PertTorque_opt, accEMG_opt, velEMG_opt, posEMG_opt, EMG_opt, posFB_opt, velFB_opt, accFB_opt] = ...
    RunFBSim(ModelName, m, L, g, time, ICs, ka_opt, kv_opt, kp_opt, tau, lambda, PertAmplitude, PertPeriod, PertWidth, PertDelay);


figure
subplot(3,1,1)
hold on
plot(Theta_unopt)
plot(Theta_opt)
title('Theta')
subplot(3,1,2)
hold on
plot(PertTorque_unopt)
plot(PertTorque_opt)
title('Pert')
subplot(3,1,3)
hold on
plot(EMG_unopt)
plot(EMG_opt)
title('EMG')
sgtitle('Optimize vs Unoptimized Simulation')
legend('Unoptimized','Optimized')

figure
hold on
plot(accEMG_opt,'r-')
plot(velEMG_opt,'b-')
plot(posEMG_opt,'m-')
plot(EMG_opt,'k')

title('Optimized EMG components')
legend('Acceleration Component','Velocity Component','Position Component','Reconstruction')



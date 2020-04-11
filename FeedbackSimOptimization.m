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
time = linspace(0, 0.6, 1500); %Simulation duration (s)


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

[Theta_unopt, dTheta_unopt, d2Theta_unopt, PertTorque_unopt, accEMG_unopt, velEMG_unopt, posEMG_unopt, EMG_unopt, posFB_unopt, velFB_unopt, accFB_unopt] = ...
    RunFBSim(ModelName, m, L, g, time, ICs, ka, kv, kp, tau, lambda, PertAmplitude, PertPeriod, PertWidth, PertDelay);

x0 = [kp, kv, ka];
A = []; %Linear Inequality Constraints
b = []; %Linear Inequality Constraints
Aeq = []; %Linear equality Constraints
beq = []; %Linear equality Constraints
LB = [0 0 0]; %Lower Bound 
UB = [10 10 10]; %Upper Bound
nonlcon = []; %Nonlinear Constraints
options_optimization = optimoptions('fmincon','Display','iter');

Optimization = fmincon(RunFBSim_Opt(ModelName, m, L, g, time, ICs, ka, kv, kp, tau, lambda, PertAmplitude, PertPeriod, PertWidth, PertDelay),...
    x0,A,B,Aeq,Beq,LB, UB,nonlcon,options_optimization)

[Theta_opt, dTheta_opt, d2Theta_opt, PertTorque_opt, accEMG_opt, velEMG_opt, posEMG_opt, EMG_opt, posFB_opt, velFB_opt, accFB_opt] = ...
    RunFBSim(ModelName, m, L, g, time, ICs, ka, kv, kp, tau, lambda, PertAmplitude, PertPeriod, PertWidth, PertDelay)


figure
plot(Theta_unopt)
hold on
plot(Theta_opt)


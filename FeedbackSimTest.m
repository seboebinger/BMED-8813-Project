%% Test of the feedback pendulum model for BMED8813 project
clear; close all
fdir = 'C:\Users\seboe\Documents\Grad School\Classes\BMED 8813 Computational Neuromechanics\Project Code\BMED-8813-Project\savedfigs\BasePendulum\'; %save directory for figures
color = ['k' 'r' 'b' 'm' 'c' 'g']; %Colors for plot

% Constant Simulink Parameters
g = 9.81; %m/s^2
m = 4; %kg (Value taken from Lockhart and Ting 2007)
L = 0.2; %m (Value taken from Lockhart and Ting 2007)
time = linspace(0, 5, 0.6); %in seconds
FBdelay = 31/1000; %Feedback delay (s)

%% Verify Passive Pendulum Dynamics with different Initial Conditions, Damping and Stiffness
%Vary ICs, stiffness and damping
K = 1; %N/rad
B = 0.25; %Ns/rad
ICs = [pi 0]; %Initial conditions [Position Velocity]

%Set perturbation to 0
% PertPeriod = 2*pi*sqrt(L/g);
PertPeriod = time(end); %period of perturbation (s)
PertAmplitude = 0; %Amplitude of perturbation  (Nrad)
PertWidth = 10; %Width of perturbation (% of period)
PertDelay = 3; %Phase delay of perturbation

%Vary Initial Conditions and plot
ModelName = 'FeedbackSim';
figure ('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(ICs)
    [Theta, PertTorque,posFB,velFB,accFB,EMG] = RunBaseSim(ModelName,m, L, K, B, g,...
        time, ICs,ka,kv,kp,tau, PertAmplitude, PertPeriod, PertWidth, PertDelay)
    subplot(3,1,1)
    hold on
    plot(Theta,color(i))
    
end

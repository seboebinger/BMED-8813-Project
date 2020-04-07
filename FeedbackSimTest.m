%% Test of the feedback pendulum model for BMED8813 project
    %Note that this model does not have muscle torque contribute to the
    %muscle kinematics. 
clear; close all
fdir = 'C:\Users\seboe\Documents\Grad School\Classes\BMED 8813 Computational Neuromechanics\Project Code\BMED-8813-Project\savedfigs\BasePendulum\'; %save directory for figures
color = ['k' 'r' 'b' 'm' 'c' 'g']; %Colors for plot

% Constant Simulink Parameters
g = 9.81; %m/s^2
m = 4; %kg (Value taken from Lockhart and Ting 2007)
L = 0.2; %m (Value taken from Lockhart and Ting 2007)
lambda = 31/1000; %Feedback delay (s) (Value taken from Lockhart and Ting 2007)
tau = 40/1000; %muscle activation kinematics (s) (Value taken from Lockhart and Ting 2007)
time = linspace(0, 5, 1500); %Simulation duration (s)

%% Verify delayed feedback signal behaves as expected. 
    %
%Set initial conditions
ICs = [pi/2 0]; %Initial conditions [Position Velocity]

%Set Feedback gains
kp = 1; %position FB gain
kv = 1; %velocity FB gain
ka = 1; %acceleration FB gain

%Set perturbation to 0
% PertPeriod = 2*pi*sqrt(L/g); %natural period of the pendulum
PertPeriod = time(end); %period of perturbation (s)
PertAmplitude = 0; %Amplitude of perturbation  (Nrad)
PertWidth = 10; %Width of perturbation (% of period)
PertDelay = 3; %Phase delay of perturbation

ModelName = 'FeedbackSim';

[Theta, dTheta, d2Theta, PertTorque, accEMG, velEMG, posEMG, EMG, posFB, velFB, accFB] = ...
    RunFBSim(ModelName, m, L, g, time, ICs, ka, kv, kp, tau, lambda, PertAmplitude, PertPeriod, PertWidth, PertDelay);

figure
subplot(3,1,1)
hold on
plot(Theta,'r-')
plot(posFB,'r--')
ylabel('Theta (rad)')
title('Angle')

subplot(3,1,2)
hold on
plot(dTheta,'r-')
plot(velFB,'r--')
ylabel('dTheta/dt (rad/s)')
title('Angular Velocity')

subplot(3,1,3)
hold on
plot(d2Theta,'r-')
plot(accFB,'r--')
ylabel('d2Theta/dt2 (rad/s^2)')
xlabel('Time (s)')
title('Angular Acceleration')

sgtitle('Delayed Feedback Signals')
legend('Pendulum Kinematics','Delayed Signal')

figure
hold on
plot(EMG,'k')
plot(accEMG,'r')
plot(velEMG,'b')
plot(posEMG,'g')
plot(accEMG+velEMG+posEMG,'c--')
title('EMG Components')
legend('EMG from Simulink','Acceleration Component','Velocity Component','Position Component','Summation of each component')


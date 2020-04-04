%% Homework 5
clear; close all
fdir = 'C:\Users\seboe\Documents\Grad School\Classes\BMED 8813 Computational Neuromechanics\Project Code\BMED-8813-Project\savedfigs\BasePendulum\'; %save directory for figures
color = ['k' 'r' 'b' 'm' 'c' 'g']; %Colors for plot

% Constant Simulink Parameters
g = 9.81; %m/s^2
m = 4; %kg (Value taken from Lockhart and Ting 2007)
L = 0.2; %m (Value taken from Lockhart and Ting 2007)
time = linspace(0, 5, 1500); %in seconds

%% Verify Passive Pendulum Dynamics with different Initial Conditions
%Set Stiffness, Damping, and perturbation to 0
K = 0; %N/rad
B = 0; %Ns/rad
% PertPeriod = 2*pi*sqrt(L/g);
PertPeriod = time(end); %period of perturbation (s)
PertAmplitude = 0; %Amplitude of perturbation  (Nrad)
PertWidth = 10; %Width of perturbation (% of period)
PertDelay = 3; %Phase delay of perturbation

ICs = [0 0; pi/2 0; 2*pi/3 0; pi 0]; %Initial conditions [Position Velocity]
ModelName = 'BasePendulumSim';
figure ('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(ICs)
    [Theta, PertTorque] = RunBaseSim(ModelName,m, L, K, B, g,...
        time, ICs(i,:), PertAmplitude, PertPeriod, PertWidth, PertDelay);
    
    hold on
    plot(Theta,color(i))
    
end
ylabel('Theta (rad)')
xlabel('Time (s)')
title({'Base Pendulum Test';'Effect of Initial Conditions'})
legend('Position = 0 rad','Position = pi/2 rad','Posiiton = 2pi/3 rad','Position = pi rad')
saveas(gcf,[fdir 'IC Test ' date '.jpg'],'jpg')


%% Verify Passive Pendulum Dynamics with different Damping and Stiffness
% %Vary stiffness and damping
% K = [0 1 5 10]; %N/rad
% B = [0 0.25 0.5 1]; %Ns/rad
% 
% %Set perturbation to 0
% % PertPeriod = 2*pi*sqrt(L/g);
% PertPeriod = time(end); %period of perturbation (s)
% PertAmplitude = 0; %Amplitude of perturbation  (Nrad)
% PertWidth = 10; %Width of perturbation (% of period)
% PertDelay = 3; %Phase delay of perturbation
% 
% ICs = [pi/2 0]; %Initial conditions [Position Velocity]
% ModelName = 'BasePendulumSim';
% figure ('units','normalized','outerposition',[0 0 1 1])
% %vary Stiffness and plot
% for i = 1:length(K)
%     [Theta, PertTorque] = RunBaseSim(ModelName,m, L, K(i), B(1), g,...
%         time, ICs, PertAmplitude, PertPeriod, PertWidth, PertDelay);
%     
%     subplot(2,1,1)
%     hold on
%     plot(Theta,color(i))
%     ylabel('Theta (rad)')
%     
% end
% title('Effect of Stiffness')
% legend(['K = ' num2str(K(1)) 'N/rad'],['K = ' num2str(K(2)) 'N/rad'],['K = ' num2str(K(3)) 'N/rad'],['K = ' num2str(K(4)) 'N/rad'])
% 
% %vary Damping and plot
% for i = 1:length(B)
%     [Theta, PertTorque] = RunBaseSim(ModelName,m, L, K(1), B(i), g,...
%         time, ICs, PertAmplitude, PertPeriod, PertWidth, PertDelay);
%     
%     subplot(2,1,2)
%     hold on
%     plot(Theta,color(i))
%     ylabel('Theta (rad)')
%     
% end
% xlabel('Time (s)')
% title('Effect of Damping')
% legend(['B = ' num2str(B(1)) 'Ns/rad'],['B = ' num2str(B(2)) 'Ns/rad'],['B = ' num2str(B(3)) 'Ns/rad'],['B = ' num2str(B(4)) 'Ns/rad'])
% 
% sgtitle({'Base Pendulum Test'})
% 
% saveas(gcf,[fdir 'B and K Test ' date '.jpg'],'jpg')

%% Verify that the perturbation torque when initial position is at an equilibrium point
%Set Stiffness, Damping, and perturbation to 0
K = 0;
B = 0.25;
% PertPeriod = 2*pi*sqrt(L/g);
PertPeriod = time(end); %period of perturbation (s)
PertAmplitude = -1*[0 1 2 5]; %Amplitude of perturbation  (Nrad)
PertWidth = 5; %Width of perturbation (% of period)
PertDelay = 1; %Phase delay of perturbation

ModelName = 'BasePendulumSim';

% %Vary pert torque when pendulum is in a down position
% ICs = [0 0]; %Initial conditions [Position Velocity]
% figure ('units','normalized','outerposition',[0 0 1 1])
% for i = 1:length(PertAmplitude)
%     [Theta, PertTorque] = RunBaseSim(ModelName,m, L, K, B, g,...
%         time, ICs, PertAmplitude(i), PertPeriod, PertWidth, PertDelay);
%     
%     subplot(2,1,1)
%     hold on
%     plot(Theta,color(i))
%     title('Pendulum Angle')
%     ylabel('Theta (rad)')
%     subplot(2,1,2)
%     hold on
%     plot(PertTorque,color(i))
%     title('Perturbation Torque')
%     ylabel('Torque (Nrad)')
%     ylim([-6 1])
%     
% end
% xlabel('Time (s)')
% title({'Base Pendulum Test';'Effect of Perturbation Torque When Pendulum is Down'})
% legend(['Pert Torque = ' num2str(PertAmplitude(1)) 'Nrad'],['Pert Torque = ' num2str(PertAmplitude(2)) 'Nrad'],...
%     ['Pert Torque = ' num2str(PertAmplitude(3)) 'Nrad'],['Pert Torque = ' num2str(PertAmplitude(4)) 'Nrad'])
% saveas(gcf,[fdir 'Pert Test Down Pendulum ' date '.jpg'],'jpg')


%Vary pert torque when pendulum is in an up position
ICs = [pi 0]; %Initial conditions [Position Velocity]
figure ('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(PertAmplitude)
    [Theta, PertTorque] = RunBaseSim(ModelName,m, L, K, B, g,...
        time, ICs, PertAmplitude(i), PertPeriod, PertWidth, PertDelay);
    
    subplot(2,1,1)
    hold on
    plot(Theta,color(i))
    title('Pendulum Angle')
    ylabel('Theta (rad)')
    subplot(2,1,2)
    hold on
    plot(PertTorque,color(i))
    title('Perturbation Torque')
    ylabel('Torque (Nrad)')
    ylim([-6 1])
    
end
xlabel('Time (s)')
title({'Base Pendulum Test';'Effect of Perturbation Torque When Pendulum is Up'})
legend(['Pert Torque = ' num2str(PertAmplitude(1)) 'Nrad'],['Pert Torque = ' num2str(PertAmplitude(2)) 'Nrad'],...
    ['Pert Torque = ' num2str(PertAmplitude(3)) 'Nrad'],['Pert Torque = ' num2str(PertAmplitude(4)) 'Nrad'])
saveas(gcf,[fdir 'Pert Test Up Pendulum K_' num2str(K) ' B_' num2str(B) ' ' date '.jpg'],'jpg')
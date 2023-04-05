%% INITIALIZE

clearvars
close all
clc

%% GENERATE SIGNALS

% Parameters
N         = 500;
mu        = [0,0];
sigma     = [6,1];
rot1      = eye(2);          % Rotation for data1
theta     = 15*pi/180;       % Angle of rotation for data2
rot2      = [cos(theta) -sin(theta); sin(theta) cos(theta)];

% Generate signals
X1        = (rot1*(repmat(mu,N,1)+ randn(N,2).*repmat(sigma,N,1))')';
X2        = (rot2*(repmat(mu,N,1)+ randn(N,2).*repmat(sigma,N,1))')';
d1        = rot1*[1;0];
d2        = rot2*[1;0];

% Plot raw signals
figure
subplot(2,1,1), plot(X1), legend('Channel 1','Channel 2'), grid on, box on
xlabel('Samples'), ylabel('Amplitude'), title('Raw signals for positive class')
subplot(2,1,2), plot(X2), legend('Channel 1','Channel 2'), grid on, box on
xlabel('Samples'), ylabel('Amplitude'), title('Raw signals for negative class')

figure, hold on
scatter(X1(:,1), X1(:,2))
scatter(X2(:,1), X2(:,2))
plot([0 d1(1)].*max(X1(:)), [0 d1(2)].*max(X1(:)), 'linewidth',2)
plot([0 d2(1)].*max(X2(:)), [0 d2(2)].*max(X2(:)), 'linewidth',2)
grid on, box on
legend('class 1', 'class 2', 'd_1','d_2')
title('Before CSP filtering');
xlabel('Channel 1'); ylabel('Channel 2');



%% COMPUTE CSP

% Compute CSP
[W,l,A]   = CSP(X1',X2');

% Compute transformed signals
X1_CSP    = (W'*X1')';
X2_CSP    = (W'*X2')';



%% PLOT RESULTS

% Plot CSP signals
figure
subplot(2,1,1), plot(X1_CSP), legend('CSP 1','CSP 2'), grid on, box on
xlabel('Samples'), ylabel('Amplitude'), title('CSP signals for positive class')
subplot(2,1,2), plot(X2_CSP), legend('CSP 1','CSP 2'), grid on, box on
xlabel('Samples'), ylabel('Amplitude'), title('CSP signals for negative class')

% Plot raw and CSP data
figure

subplot(1,2,1), hold on
scatter(X1(:,1), X1(:,2),'.')
scatter(X2(:,1), X2(:,2),'.')
plot([0 d1(1)].*max(X1(:)), [0 d1(2)].*max(X1(:)), 'linewidth',2)
plot([0 d2(1)].*max(X2(:)), [0 d2(2)].*max(X2(:)), 'linewidth',2)
grid on, box on, axis square
legend('class 1', 'class 2'), title('Before CSP filtering')
xlabel('Channel 1'), ylabel('Channel 2')

subplot(1,2,2), hold on
scatter(X1_CSP(:,1), X1_CSP(:,2),'.')
scatter(X2_CSP(:,1), X2_CSP(:,2),'.')
grid on, box on, axis square
legend('class 1', 'class 2'), title('After CSP filtering')
xlabel('CSP 1'), ylabel('CSP 2')
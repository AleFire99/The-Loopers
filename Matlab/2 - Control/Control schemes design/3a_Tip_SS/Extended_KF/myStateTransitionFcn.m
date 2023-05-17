function [theta ,theta_dot, alpha, alpha_dot, diverge_Ks, diverge_JL] = myStateTransitionFcn(theta,theta_dot,alpha,alpha_dot,u)

dt = sysest.Ts;
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
diverge_Ks = 1;
diverge_JL = 1;
theta = theta + dt * theta_dot;
theta_dot =  0.9283 *theta_dot+diverge_Ks*1.1622*alpha+0.0017*alpha_dot;
alpha = alpha + dt * alpha_dot;
alpha_dot = 0.0717 * theta_dot - diverge_Ks*diverge_JL*1.9309 + diverge_JL * 0.9972;
diverge_Ks_dot = 0;
diverge_JL_dot = 0;
end


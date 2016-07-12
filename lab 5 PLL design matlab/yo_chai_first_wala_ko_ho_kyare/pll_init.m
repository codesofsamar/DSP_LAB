
function [state] = pll_init(f,D,k,w0)
% [state] = pll_init(h, Ns);
%
% Creates a new pll filter.
%
% Inputs:
% h Filter taps
% Ns Number of samples processed per block
% Outputs:
% state Initial state
%% 1. Save parameters
% Store the filter taps
% Store the number of samples processed per block
%% 2. Create state variables
state.f = f;
state.D = D;
state.k = k;
state.w0 = 2*pi/100;
state.T = 1;
state.x_in_old = 0;
state.y_out_old = 0;
state.z_old = 0;
state.v_old = 0;
state.accum = 0;
tau1 = k/(w0*w0);
tau2 = 2*D/w0-1/k;
state.a1=-(state.T-2*tau1)/(state.T+2*tau1);
state.b0=(state.T+2*tau2)/(state.T+2*tau1);
state.b1=(state.T-2*tau2)/(state.T+2*tau1);
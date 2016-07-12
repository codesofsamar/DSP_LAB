function [si, str_state, str_debug] = str(Ib, Qb, state_in)
str_state = state_in;
si = zeros(length(Ib),1);
Tc2 = floor(p.Tc/2);

if isempty(state_in) 
    str_state.delay = [];
    str_state.pll_state = [];
    accum_prev = 0;
else
    state = state_in;
end

%% delay the input by Tc / 2
[str_state.delay_state, delay_out] = delay(str_state.delay_state, Ib);

%% multiply the delayed waveform and Ib
y1 = Ib.*delay_out;

%% input the product to the pll
[ref, accum, str_state.pll_state] = pll(y1, str_state.pll_state);

%% finding out zero crossing
accum_prev = str_state.accum_prev;
accum1 = accum + str_state.ft;
accum_prev1 = accum_prev + str_state.ft;

if accum1(1) >= 0.75 && accum_prev1 <= 0.75
    si(1) = 1;
end

for i = 2:length(Ib)
    if accum1(i) >= 0.75 && accum_prev1(i-1) <= 0.75
    si(i) = 1;
    end
end

%%
str_debug = [];
str_state.accum_prev = accum(i);




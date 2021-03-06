function [si, str_state, str_debug] = str(Ib, Qb, p, state_in)
%state_str = state_in;
si = zeros(length(Ib),1);
%p.Tc = floor(p.Tc/2);

%% delay the input by Tc / 2
[p.delay_state, delay_out] = delay(floor(p.Tc/2), Ib);

%% multiply the delayed waveform and Ib
y1 = Ib.*delay_out;

%% input the product to the pll
[ref, accum, p.pll_state] = pll(y1, p.pll_state);

%% finding out zero crossing
accum_prev = p.accum_prev;
accum1 = accum + p.ft;
accum_prev1 = accum_prev + p.ft;

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
p.accum_prev = accum(i);




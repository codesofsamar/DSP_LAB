load ref_stepf.mat;

Nb = 10;	% Number of buffers
Ns = length(ref_in)/Nb;	% Samples in each buffer
freq = 0.1;
damping_ratio = 1.0;
loop_gain = 1.0;
loop_corner_freq = pi/50;
sample_rate = 8000;
accum = 0.0;


pll_in = pll_init(Ns, freq, damping_ratio, loop_gain, loop_corner_freq);

xb = reshape(ref_in, Ns, Nb);  

yb = zeros(Ns, Nb);
  

for bi = 0:Nb-1,
   [pll_in, yb(:,bi + 1)] = pll(pll_in, xb(:,bi + 1)); 
end
 
%Reshape the output;
y = reshape(yb, Ns*Nb, 1);
 
plot(n, ref_in);
hold on;
plot(n, y,'r');

%xlim([600 700]);
% Compute approximate transfer function using PSD
%Npsd = 200;	% Blocksize (# of freq) for PSD
%[Y1 f1] = psd1(y, Npsd);
%[X1 f1] = psd1(x, Npsd);
%plot(f1, abs(sqrt(Y1./X1)), f, abs(H));
%xlim([0 0.2]);
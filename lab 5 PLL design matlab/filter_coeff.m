f = 0.1;
D = 1.0;
k = 2.0;
w0=2*pi/100;

T1 = k/(w0^2);
T2 = (2*D/w0)-(1/k);

T = 1;

a1 = -((T-2*T1)/(T+2*T1));
b0 = ((T+2*T2)/(T+2*T1));
b1 = ((T-2*T2)/(T+2*T1));



theta = deg2rad(120);
alpha = deg2rad(1.5);
d = 200;
D0 = 70;
x = [-800 -600 -400 -200 0 200 400 600 800];
D = D0-x*tan(alpha);
W = 2*D/cos(theta/2-alpha)/(1/sin(theta/2)-tan(alpha)/cos(theta/2));
eta = 1-d./(cos(alpha)*W);
eta(1) = 0;
[x;D;W;eta]
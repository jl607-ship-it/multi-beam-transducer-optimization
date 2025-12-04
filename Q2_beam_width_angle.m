theta = deg2rad(120);
alpha = deg2rad(1.5);
beta = [0;45;90;135;180;225;270;315];
beta = deg2rad(beta);
d = 0.3*1852;
D0 = 120;
x = [0 0.3 0.6 0.9 1.2 1.5 1.8 2.1];
x = x*1852;      %Conversion between nautical miles and meters
for i=1:8
    for j=1:8
        D(i,j) = D0+x(j).*tan(alpha).*cos(beta(i));
    end
end
W = 2*D/cos(theta/2-alpha)/(1/sin(theta/2)-tan(alpha)/cos(theta/2));
W
%% Known Conditions
% beta and d are unknown variables
% Set the southwest corner of the sea area as the origin,
% with East as the positive x-axis and North as the positive y-axis.
theta = deg2rad(120);   
alpha = deg2rad(1.5);
eta_min = 0.1;   % Minimum overlap rate
eta_max = 0.2;   % Maximum overlap rate
D0 = 110;        % Water depth at the center position

%% Solve for the range of value d
W0 = 2*D0/cos(theta/2-alpha)/(1/sin(theta/2)-tan(alpha)/cos(theta/2));  % Swath width at the center position
d_min = (1-eta_max)*(cos(alpha)*W0);   % Calculate the range of d: maximum and minimum values
d_max = (1-eta_min)*(cos(alpha)*W0);

%% Select initial position values
% Next, consider the nearest initial position selected to cover the top-left or bottom-left point.
% In this problem, since the slope of the parallel lines is fixed, opposite directions 
% yield the same result. For calculation simplicity, simplify beta range to [0, pi].
beta = 0:deg2rad(5):pi;
d = d_min:(d_max-d_min)/20:d_max;

% First, the survey lines are a family of parallel lines with a fixed slope, so let the equation be y=kx+b.
% Secondly, for calculation convenience, calculate the sum of distances of lines on the positive y-axis, 
% then use trigonometry to get total accumulated line length.
W = W0;
k = beta-pi/2;
for i=1:37
    a(i) = W*cos(beta(i))*(cos(alpha)+sin(alpha)*tan(theta/2));     % a is the distance between lines B and C (in the diagram)
    a(i) = abs(a(i));
    if beta(i)==0
        a0(i)=a(i)/2;
    elseif beta(i)==pi
        a0(i)=a(i)/2;
    else 
        a0(i) = a(i)/2/cos(beta(i)-pi/2); % a0 is the distance on the y-axis of the nearest survey line to the starting point (top-left or bottom-left)
        a0(i)=abs(a0(i));
    end
end

%% Calculate ray (line) distances
sum = 0;
for i=1:37
    for j=1:21
         if beta(i)>pi/2 && beta(i)<pi
            for m=1:100
                b(m) = (2*1852-a0(i))-(m-1)*d(j)/cos(k(i));
            end
            % Consider the first region, where the line family intersects the positive y-axis [0,2] (unit: nautical miles)   
            m1 = b(1)/(d(j)/cos(k(i)));    % m1 is the number of intersection points (excluding the starting point)
            m1 = floor(m1);
            if m1>0
                for m=1:m1+1
                    sum = sum+(2*1852-b(m));
                end
            else
                sum = sum;
                m1 = 0;
            end
            % Second region, the length of the line family within the specified area is 2(NM)/sin(beta-pi/2)
            m2 = (4*1852-((2*1852-b(m1+1))/tan(k(i))))/(d(j)/sin(k(i)));
            m2 = floor(m2);
            if m2>0
                sum = sum+2*1852*m2;
            else
                sum = sum;
                m2 = 0;
            end
            % Third region, lines intersecting with the right side of the specified area
            m3 = (4*1852-(-b(m1+m2+1))/tan(k(i)))/(d(j)/sin(k(i)));
            m3 = floor(m3);
            if m3>0
                for m=1:m3
                    sum = sum+(4*1852+b(m1+m2+1)/tan(k(i))-m*d(j))*tan(k(i));
                end
                n(j,i)=m1+m2+m3;
                sum = sum/sin(k(i));
            else
                m3 = 0;
                sum =sum;
                n(j,i)=m1+m2+m3;
                sum = sum/sin(k(i));
            end
         % Second case     
         elseif beta(i)<pi/2 && beta(i)>0
            % Consider the first region, where the line family intersects the positive y-axis [0,2] (unit: nautical miles)
            for m=1:100
                b(m) = a0(i)+(m-1)*d(j)/cos(-k(i));
            end
            m11 = (2*1852-b(m))/(d(j)/cos(-k(i)));    % m1 is the number of intersection points (excluding the starting point)
            m11 = floor(m11);
            if m11<0
                m11=0;
                sum = sum;
            else
                for m=1:m11+1
                    sum = sum+b(m);
                end
            end
            % Second region, the length of the line family within the specified area is 2(NM)/sin(beta-pi/2)
            m22 = (4*1852-b(m11+1)/tan(k(i)))/(d(j)/sin(-k(i)));
            m22 = floor(m22);
            if m22>0
                sum = sum+2*1852*m22;
            else
                sum = sum;
                m22 = 0;
            end
            % Third region, lines intersecting with the right side of the specified area
            m33 = (4*1852-((b(m11+m22+1)-2*1852)*tan(-k(i))))/(d(j)/sin(-k(i)));
            m33 = floor(m33);
            if m33>0
                for m=1:m33
                    sum = sum+(4*1852-(b(m11+m22+1)-2*1852)*tan(-k(i))-m*d(j))*tan(-k(i));
                    n(j,i)=m11+m22+m33;
                end
                sum = sum/sin(-k(i));
            else
                m33=0;
                sum=sum;
                n(j,i)=m11+m22+m33;
                sum = sum/sin(-k(i));
            end
         elseif beta(i)==pi/2
             n(j,i)=floor((2*1852-a0(i))/d(j));
             sum = sum+n(j,i)*4*1852;
         else
             n(j,i)=floor((4*1852-a0(i))/d(j));
             sum = sum+n(j,i)*2*1852;
         end
         z(j,i)=sum;
    end
    sum = 0;
    b = [];
end

%% Results
[x,y] = find(z==min(min(z)));
fprintf('Minimum survey length: %fm\n',(min(min(z))))
% Note: beta is in radians in the calculation, converting to degrees for display might be needed unless raw input is desired
fprintf('Angle with North-South direction: %d (radians/index value)\n',beta(y)) 
fprintf('Spacing: %fm\n',d(x))
fprintf('Total number of lines: %d\n',n(x,y))
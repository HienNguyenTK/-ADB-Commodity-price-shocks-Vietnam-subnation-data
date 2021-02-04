function [Vyr,Vxr,Vy,Vx]=variance_decomposition(gx,hx,ETA1,ETA2)
%[Vyr,Vxr,Vy,Vx]=variance_decomposition(gx,hx,ETA1) computes 
%the variance decomposition of y and x, 
%where y and x evolve according to
% x_t+1 = hx x_t + ETA1 epsilon_t+1
% y_t = gx x_t
% epsilon_t ~ iidN(0,I)
%Vyr and Vxr are variance decompositions  expressed as fractions of the total 
%variance. 
%Element (i,j) of Vyr indicates the share of the variance of element j of the vector y_t  that is explained by element i of the innovation vector epsilon_t.  
%The matrices  Vy and Vx are variance decompositons expressed in levels.  
%[Vy,Vx]=variance_decomposition(gx,hx,ETA1,ETA2) 
%computes the variance decomposition of y and x, 
%where y and x evolve according to
% x_t+1 = hx x_t + ETA1 epsilon_t+1
% y_t = gx x_t + ETA2 mu_t
% epsilon_t ~ iidN(0,I) and mu_t ~ iidN(0,I) 
% E(epsilon_t mu_T) = 0 for all t,T
% (c) Martin Uribe, February 2009

Vy = [];
Vx = [];


n1 = size(ETA1,2);

for j = 1:n1
I1 = zeros(n1);

I1(j,j) = 1;

V1 = ETA1*I1*ETA1';

[sigy,sigx] = mom(gx,hx,V1);

Vy = [Vy;diag(sigy)'];
Vx = [Vx;diag(sigx)'];

end


if nargin == 4

n2 = size(ETA2,2);

for j = 1:n2
I2 = zeros(n2);

I2(j,j) = 1;

V2 = ETA2*I2*ETA2';

Vy = [Vy;diag(V2)'];

end %for j=1:n2

end %if nargin==4

Vyr = bsxfun(@rdivide,Vy,sum(Vy,1));
Vxr = bsxfun(@rdivide,Vx,sum(Vx,1));
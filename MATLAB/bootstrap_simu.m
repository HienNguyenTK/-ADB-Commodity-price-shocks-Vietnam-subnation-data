function Y = bsimu(hx,e,y0)
%Y = bootstrap(hx,e) applies a bootstrapping method to simulate the system y_t = hx * y_t-1 + e_t with initial condition y0, and given innovations e. hx is an nxn square matrix  of coefficients,  e is a Txn matrix of innovations, and y0 is an nx1 vector of initial conditions. 
% © Martín Uribe, September 2016

T = size(e,1);
n = size(hx,1);
y = y0;
for t=1:T
i = randi(T);
y = hx*y+e(i,:)';
Y(t,1:n) = y';
end
Y = [y0';Y];

 
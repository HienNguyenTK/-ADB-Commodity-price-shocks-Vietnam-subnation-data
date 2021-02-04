%[hx,ETA,R2,A,B,stdu,u] = svar_estim(a,R,cholesky);
%estimate the matrices hx and ETA defining  the  structural vector autoregressive system
%x_t = hx x_t-1 + ETA e_t
%The identification assumption is that the matrix ETA is lower triangular. The innovation e_t~(0,I); 
%The data are contained  in the matrix a. Each row of a is an observation and each column is  a regressor.
%The input cholesky takes the values 1 or 0 (the default value is 1). If cholesky=1 then hx and ETA are obtained  by OLS estimation (equation by equation) of  the system
%x_t = hx  x_t-1 + u_t
%and then  calculating ETA as the lower Cholesky decomposition of the variance/covariance matrix of the estimated residuals u_t.
%If cholesky==0, then hx and ETA are obtained by first estimatiing by OLS (equation by equation) of the system
%x_t = Bx_t-1 + Ax_t+ u_t
%where A is restricted to be   lower triangular   with zeros along the main diagonal.   By construction, cov(u_t) is diagonal. 
%Then, hx = inv(I-A)B and ETA=inv(I-A) diag(std(u_t)).
%The matrix R introduces zero restrictions on the coefficients of hx (B) if 
%cholesky=1(=0). Spcifically, if R(i,j)=0 and cholesky=1(=0), 
%then hx(i,j) (B(i,j)) is restricted to be 0, whereas if R(i,j)=1, then 
%hx(i,j) (B(i,j)) is unrestricted. The default is R(i,j)=1 for all i,j  (use [] to invoke the default).  
%R2 is a vector of R-squares for each equation. 
%stdu is a vector of standard deviations of u_t
%u is a matrix such that u(t,:)=u_t'
%The two estimation methods (cholesky=1,0) give identical results when the system is unrestricted (all entries of R equal to 1), but not necessarily when the system has some zero restrictions. 
%This program can be used to estimate higher-order SVAR systems, since a higher-order system can always be reduced to a first-order system by an appropriate redefinition of variables. 
%© Martín Uribe, May 2016.
function [hx,ETA,R2,A,B,stdu,u] = svar_estim(a,R,cholesky);

if nargin<2 | isempty(R)
R = ones(size(a,2));
end

if nargin<3
cholesky = 1;
end

nq = size(a,2); %number of equations in the svar system

a1 = lagg(a);

D = a1(:,1:nq); %data 
D1 = a1(:,1+nq:2*nq); %lagged data
T = size(D,1); %time length
cons = ones(T,1); %constant 

hx = zeros(nq);
ETA = zeros(nq);
A = [];
B = [];
u = zeros(T,nq);

if cholesky == 1
for i = 1:nq
r = find(R(i,:)==1);
x = [D1(:,r) cons]; %independent variables
y = D(:,i); %dependent variable
b = x\y; %OLS regression coefficients
u(:,i) =  y - x*b; %estimated residuals
hx(i,r) = b(1:end-1);
end
ETA = chol(cov(u),'lower');
end

if cholesky==0
A = zeros(nq);
B = zeros(nq);
for i=1:nq
r = find(R(i,:)==1);
sr = length(r); %# of unrestricted coefficients
x = [D1(:,r) D(:,1:i-1) cons];
y = D(:,i);
b = x\y;
u(:,i) =  y - x*b;
B(i,r) = b(1:sr);
A(i,1:i-1) = b(sr+1:sr+i-1);
end
hx = (eye(nq)-A)\B;
ETA = (eye(nq)-A)\diag(std(u));
end
R2 = (1-var(u)./var(D))'; %Vector of R-square statistics
stdu = std(u); stdu = stdu(:);
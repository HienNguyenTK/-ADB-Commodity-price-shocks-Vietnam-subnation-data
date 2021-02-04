DD{k} = yall(:,[ngcom ntot necon ninf nir nrer],k); 
    %current data, each page is a region
    %change row in yall to 60:91 for restricted Vietnam data 2011Q1-2018Q4
d{k} = lagg(DD{k},lag); 
    %d{k} is Z_t (LHS) containing 0-1-2-3 lagged data when nlags=4
    
nv = size(d{1},2);  
    %no. of variables in system VAR(p)
sigx = zeros(nv,nv,nreg);
R2 = zeros(nv,nreg); 
    %R-squared by equation by region
U = cell(0); 
    %residuals

R = ones(nv); 
    %restriction matrix on hx, varies upon VAR(p)
if nlags == 4 %for (longer) country data
    R(1,[2:6, 8:12, 14:18, 20:24]) = 0; %global price univariate
	R(2,[3:6, 9:12, 15:18, 21:24]) = 0; %tot determined by itself & global price
	R(7:end,:) = zeros(18,24);  %x_{t-1}, x_{t-2}, x_{t-3} determined by themselves 
	R(7:end,1:18) = eye(18);
elseif nlags == 1 %for (short) regional data
    R(1,2:end) = 0; %restriction on hx (global price univariate univariate)
    R(2,3:end) = 0; %tot determined by itself & global price
end

y0 = zeros(nreg,nv); 
    %Initial condition for bootstrapping

data = d{k};
y0(k,:) = data(1,:);

%Estimate by OLS the system Z_t = B*Z_t-1 + A*Z_t + u_t, and set PI = (I-A)\B and PI= (I-A)\diag(stdu) (note: by construction, the var-cov of u_t is diagonal), to get Z_t = hx*Z_t-1 +PI*e_t, where u_t = PI*e_t
[hx(:,:,k),PI(:,:,k),R2(:,k),A(:,:,k),B(:,:,k),stdu(:,k),U{k}] = svar_estim(data,R,0);

EIG(ngcom,k) = max(abs(eig(hx(:,:,k)))); %Maximum eigenvalue

%Calculate Cholesky variance share of each variable explained by shock
[~,vdx] = variance_decomposition(eye(nv),hx(:,:,k),PI(:,:,k));
v_share(ngcom,:,k) = round(vdx(1,1:nvar)*100,2);

%Impulse Responses to global comm. price shock
x0 = PI(:,1,k)/PI(1,1,k);
x = ir(eye(nv),hx(:,:,k),x0,Tirf); 
IR(:,:,k) = x(:,1:nv); %orthogonalized impulse responses (IRFs)
cIR(:,:,k) = cumsum(IR(:,:,k)); %cumulative IRFs

%save IRFs, cIRFs by region/shock
sIR(:,:,k,ngcom) = IR(:,:,k);
scIR(:,:,k,ngcom) = cIR(:,:,k);
N = 1e4; %no. of replications
f = 0.68; %confidence band width
n1 = round((1-f)/2*N); %lower band
n2 = round((1+f)/2*N); %upper band

hx_k = hx(:,:,k);
PI_k = PI(:,:,k);
u = U{k};
e = u*(PI_k*inv(diag(std(u))))';
y0_k = y0(k,:)';
IR_sim = zeros(Tirf,nv);
    
for n = 1:N
    Y = bootstrap_simu(hx_k,e,y0_k);
    [shx,sPI,sR2,sA,sB,sstdu,sU] = svar_estim(Y,R,0); %SVAR estimation based on new Inital conditions
    x0 = sPI(:,1)/sPI(1,1);
    x = ir(eye(nv),shx,x0,Tirf); %IRFs based on new Inital conditions
    IR_sim(:,:,n) = x(:,1:nv);
end

%orthogonalized impulse responses
sIR_sim = sort(IR_sim,3); %IRFs to global comm. price shock
IR1(:,:,k) = sIR_sim(:,:,n1); %lower band of 68%CI
IR2(:,:,k) = sIR_sim(:,:,n2); %upper band of 68%CI

%cumulative orthogonalized impulse responses
cIR_sim = cumsum(IR_sim); %cumulative IRFs to global comm. price shock
csIR_sim = sort(cIR_sim,3); 
cIR1(:,:,k) = csIR_sim(:,:,n1); %lower band of 68% cumulative CI
cIR2(:,:,k) = csIR_sim(:,:,n2); %upper band of 68% cumulative CI

%save 68%CIs by region/shock
sIR1(:,:,k,ngcom) = IR1(:,:,k);
sIR2(:,:,k,ngcom) = IR2(:,:,k);
scIR1(:,:,k,ngcom) = cIR1(:,:,k);
scIR2(:,:,k,ngcom) = cIR2(:,:,k);

'Done bootstrapping: Global shock'
ngcom
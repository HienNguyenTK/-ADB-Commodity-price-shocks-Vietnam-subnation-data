    regionnames = {'Vietnam'};%region name
    nreg = size(regionnames,1); %number of regions
    shocknames = {'Energy price';'Agriculture price';'Beverages price';'Food price';'Vegetable oils and meals price';'Cereal price';'Other food price';'Raw materials price';'Timber price';'Other raw materials price';'Metal price'};%global shock names
    load country.txt;
%transform variables: global comm. price
    energy = 100*(log(country(2:end,1)) - log(country(1:end-1,1))); % col 1 = energy price 
    agri = 100*(log(country(2:end,2)) - log(country(1:end-1,2))); % col 2 = agriculture price
    bev = 100*(log(country(2:end,3)) - log(country(1:end-1,3))); % col 3 = beverages price
    food = 100*(log(country(2:end,4)) - log(country(1:end-1,4))); % col 4 = food price
    fats = 100*(log(country(2:end,5)) - log(country(1:end-1,5))); % col 5 = fats & oils meals price
    cereal = 100*(log(country(2:end,6)) - log(country(1:end-1,6))); % col 6 = cereal price
    otfood = 100*(log(country(2:end,7)) - log(country(1:end-1,7))); % col 7 = other food price
    material = 100*(log(country(2:end,8)) - log(country(1:end-1,8))); % col 8 = raw materials price
    timber = 100*(log(country(2:end,9)) - log(country(1:end-1,9))); % col 9 = timber price
    otmaterial = 100*(log(country(2:end,10)) - log(country(1:end-1,10))); % col 10 = other raw materials price
    metal = 100*(log(country(2:end,11)) - log(country(1:end-1,11))); % col 11 = metal price
    %transform variables: country comm. TOT
    totr = 100*(log(country(2:end,12)) - log(country(1:end-1,12))); % col 12 = TOT, rolling weighted by trade balance
    totgdpr = 100*(log(country(2:end,13)) - log(country(1:end-1,13))); % col 13 = TOT, rolling weighted by GDP
    totf = 100*(log(country(2:end,14)) - log(country(1:end-1,14))); % col 14 = TOT, fixed weighted by trade balance
    totgdpf = 100*(log(country(2:end,15)) - log(country(1:end-1,15))); % col 15 = TOT, fixed weighted by GDP
    %transform variables: country macro variables
    gdppc = 100*(log(country(2:end,16)) - log(country(1:end-1,16))); % col 16 = GDP per capita
    conpc = 100*(log(country(2:end,17)) - log(country(1:end-1,17))); % col 17 = Consumption per capita
    inf = country(2:end,18); % col 18 = q-o-q inflation
    int = country(2:end,19); % col 19 = interest rate
    ex = 100*(log(country(2:end,20)) - log(country(1:end-1,20))); % col 20 = real exchange rate
%full transformed data
    yall = [energy agri bev food fats cereal otfood material timber otmaterial metal totr totgdpr totf totgdpf gdppc conpc inf int ex];
%5 domestic varibles
    ntot = 12; %can change to column 13-14-15 for other commodity TOT indices
    necon = 16; %GDP per capita
    %ncon = 17;
    ninf = 18;
    nir = 19;
    nrer = 20; 
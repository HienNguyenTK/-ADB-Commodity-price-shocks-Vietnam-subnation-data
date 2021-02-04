%number the (transformed) global commodity indices in yall
%yall is generated in readData.m
if docountry == 1 %use country data
    if ngcom == 1 % col 1 = energy price
        varnames = {'Global energy price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 2 % col 2 = agriculture price
        varnames = {'Global agriculture price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 3 % col 3 = beverages price
        varnames = {'Global beverage price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 4 % col 4 = food price
        varnames = {'Global food price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 5 % col 5 = fats & oils meals price
        varnames = {'Global vegetable oil and meal price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 6 % col 6 = cereal price
        varnames = {'Global cereal price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 7 % col 7 = other food price
        varnames = {'Global other food price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 8 % col 8 = raw materials price
        varnames = {'Global raw material price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 9 % col 9 = timber price
        varnames = {'Global timber price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 10 % col 10 = other raw materials price
        varnames = {'Global other raw material price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 11 % col 11 = metal price
        varnames = {'Global metal price', 'Commodity TOT', 'GDP per capita', 'Inflation', 'Interest rate', 'Real exchange rate'};
    end
    
elseif docountry == 0 %use regional data
    if ngcom == 1 % col 1 = energy price
        varnames = {'Global energy price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 2 % col 2 = agriculture price
        varnames = {'Global agriculture price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 3 % col 3 = beverages price
        varnames = {'Global beverage price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 4 % col 4 = food price
        varnames = {'Global food price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 5 % col 5 = fats & oils meals price
        varnames = {'Global vegetable oil and meal price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 6 % col 6 = cereal price
        varnames = {'Global cereal price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 7 % col 7 = other food price
        varnames = {'Global other food price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 8 % col 8 = raw materials price
        varnames = {'Global raw material price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 9 % col 9 = timber price
        varnames = {'Global timber price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 10 % col 10 = other raw materials price
        varnames = {'Global other raw material price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    elseif ngcom == 11 % col 11 = metal price
        varnames = {'Global metal price', 'Commodity TOT', 'Unemployment', 'Inflation', 'Interest rate', 'Real exchange rate'};
    end
    
end
function totalAmount = CostTransfo(puissanceMaxTransfo, OLTCneeded, transfoRatedPower, priceTranfo, priceOLTC)

toUpgrade(1,1)=false; %sécurité pour s'arrurer qu'on ne va pas doubler une ligne qui est en réalité inexistance
totalAmount=0;

if puissanceMaxTransfo>transfoRatedPower
    if OLTCneeded
        totalAmount = priceOLTC*puissanceMaxTransfo*1.4;
    else
        totalAmount = priceTranfo*puissanceMaxTransfo*1.4;
    end
end

if OLTCneeded
    totalAmount = priceOLTC*puissanceMaxTransfo*1.4;
end

end
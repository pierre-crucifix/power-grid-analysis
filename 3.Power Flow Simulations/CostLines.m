function totalAmount = CostLines(toUpgrade, coutparligne)
toUpgrade(1,1)=false; %sécurité pour s'arrurer qu'on ne va pas doubler une ligne qui est en réalité inexistance
totalAmount=0;
    
totalAmount = totalAmount + toUpgrade'*coutparligne; %On dédouble toutes les lignes qu'il y a lieu de dédoubler

end

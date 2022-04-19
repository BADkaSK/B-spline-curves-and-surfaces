function [deb_col]=bsplineplocha(P,p,q,sekv1,sekv2)

ps=size(P,2); % počet stĺpcov
pr=size(P,3); % počet riadkov  

[U,s,c]=knotvektor(pr,p,sekv2); %uzlový vektor a vektor multiplicity pre stĺpce
[V,t,d]=knotvektor(ps,q,sekv1); %uzlový vektor a vektor multiplicity pre riadky

u=linspace(0,1,sekv2); % parameter u 
v=linspace(0,1,sekv1); % parameter v 

deb_row=zeros(3,sekv2,pr);

P_z=P(3,1,1:pr);  % uložíme si súradnice z, pre jednotlivé riadky sú rovnaké, do De Boorovho algoritmu nevstupujú
	
% DEBOOROV ALGORITMUS PO RIADKOCH
for k=1:sekv1 %indexovanie podla sekvencií
   
   for i=1:pr   % riadky
        Pdyn=P(1:2,:,i); % do Pdyn si uložíme i-ty riadok
        deb_row(1:2,k,i)=deboor(P(1:2,:,i),p,V,d(k),t(k),v(k)); % na i-ty riadok aplikujeme De Boorov algoritmus
        deb_row(3,k,i)=P_z(i); % dopíšeme chýbajúcu súradnicu z
    end

end

P_x=deb_row(1,1:sekv1,1); % uložíme si súradnice x, pre jednotlivé stĺpce sú rovnaké, do De Boorovho algoritmu nevstupujú

% DEBOOROV ALGORITMUS PO STĹPCOCH
for k=1:sekv1 
    
    for i=1:pr 
        Pdyn2(:,i)=deb_row(:,k,i);  % do Pdyn2 si uložíme i-ty stĺpec
    end
    
    for i=1:sekv2
        deb2(2:3,i)=deboor(Pdyn2(2:3,:),q,U,c(i),s(i),u(i)); % na i-ty stĺpec aplikujeme De Boorov algoritmus
    end
    
    deb2(1,1:i)=P_x(k);  % dopíšeme chýbajúcu súradnicu x
    deb_col(:,:,k)=deb2; % v deb_col sú uložené hladané body B-spline plochy
    
end
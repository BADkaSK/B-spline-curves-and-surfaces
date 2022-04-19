function [P]=makegrid(B2,posun)
% zistíme začiatok a koniec mriežky a body zaokrúhlime
ZAC=min(B2);  KON=max(B2);
ZAC=round(ZAC,1); KON=round(KON,1);

% nastavíme začiatok a koniec mriežky
x0=ZAC(1,1); z0=ZAC(1,3);
xk=KON(1,1); zk=KON(1,3);

% štart mriežky
x=x0; 
z=z0;

ps=abs((x0)-(xk))/posun+1; % počet stĺpcov mriežky
pr=abs((z0)-(zk))/posun+1; % počet riadkov mriežky

lim_v=1000; % limitná vzdialenosť, žiadne 2 body nie sú ďalej od seba ako lim_v
for i=1:pr % riadky
    for k=1:ps % stĺpce
        
        min_v(1:4,1)=lim_v; % na začiatok nastavíme do minima limitnú vzdialenosť
        master_bod=0; % na začiatok nastavime neplatnú pozíciu
        
        % hladáme lineárnu kombinaciu najbližších susedov zo 4 kvadrantov
        for j=1:size(B2,1) % cyklus ide vždy cez všetky body, pretože B2 je neusporiadaná matica bodov
            
            vzdial=sqrt((B2(j,1)-x)^2+(B2(j,3)-z)^2); % výpočet vzdialenosti bodu mriežky od j-tého vstupného bodu
            
            % Bod z B2 má rovnaké súradnice x,z ako bod mriežky - nepredpokladáme viac ako 1            
            if B2(j,1)==x && B2(j,3)==z
               master_bod=j; % uložíme si pozíciu master bodu
               break; % ďalší výpočet nie je potrebný
               
            % 1.KVADRANT             
            elseif B2(j,1)>x && B2(j,3)>=z
              if vzdial<min_v(1,1)
                  min_v(1,1)=vzdial; % uložíme minimálnu vzdialenosť v prvom kvadrante
                  min_v(1,2)=j; % uložíme pozíciu bodu
                  
              end
            
            % 2.KVADRANT 
            elseif B2(j,1)<=x && B2(j,3)>z
              if vzdial<min_v(2,1)
                  min_v(2,1)=vzdial; % uložíme minimálnu vzdialenosť v druhom kvadrante
                  min_v(2,2)=j; % uložíme pozíciu bodu
              end
       
            % 3.KVADRANT
            elseif B2(j,1)<x && B2(j,3)<=z
              if vzdial<min_v(3,1)
                  min_v(3,1)=vzdial; % uložíme minimálnu vzdialenosť v treťom kvadrante
                  min_v(3,2)=j; % uložíme pozíciu bodu
              end
            
            % 4.KVADRANT
            elseif B2(j,1)>=x && B2(j,3)<z
              if vzdial<min_v(4,1)
                  min_v(4,1)=vzdial; % uložíme minimálnu vzdialenosť vo štvrtom kvadrante
                  min_v(4,2)=j; % uložíme pozíciu bodu
              end
            end
        end
        
        if master_bod>0 % našiel sa bod zhodný s mriežkovým
            y=B2(master_bod,2);
        else
            % pokiaľ sa v nejakom kvadráte nenachádza bod, vynuluje sa celý tento riadok matice min_v      
            for j=1:size(min_v,1)
                if min_v(j,1)==1000 % v j-tom kvadrante sa nenašlo minimum, ostala tam limitná vzdialenosť
                    min_v(j,1)=0; % vynulujeme kvôli výpočtu váhy
                end
            end

            m=0; y=0;
            
            % výpočet menovateľa váhy m pre najbližšie body    
            for j=1:size(min_v,1)
                if min_v(j,1)>0
                    m=m+(sum(min_v(:,1))/min_v(j,1));
                end
            end
            
            % výpočet ypsilonovej súradnice bodu mriežky
            for j=1:size(min_v,1)
                if min_v(j,1)>0 
                    c=sum(min_v(:,1))/min_v(j,1); % výpočet čitateľa váhy c
                    vaha=c/m; % výpočet váhy
                    y=y+vaha*B2(min_v(j,2),2); % výpočet ypsilonovej súradnice bodu mriežky
                end
            end
        end
        C{i,k}={x,y,z}; % uložíme bod mriežky do cellu
        x=x+posun; % posunieme sa o stĺpec
    end
    
    z=z+posun; % posunieme sa o riadok
    x=x0; % znova sa nastavíme na prvý stĺpec
end

% Prepis bodov z cellu do matice
for i=1:ps
    for j=1:pr
        P(:,i,j)=cell2mat(C{j,i});
    end
end

end
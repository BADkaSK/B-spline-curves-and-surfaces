function [U,s,k]=knotvektor(n,p,sekv)
	
	m=2;  % dimenzia riadiacich bodov
	uk=0;
	
	% naplnenie vektoru u nulami na zaciatku a u jednotkami na konci
	U(1:(p+1))=0;
	U((n+1):(p+n+1))=1;
	
	% prostredné hodnoty u dopočítame ekvidistantne 
	krok=1/(n-p);
	for i=1:(n-p-1)
		uk=uk+krok;
		U((p+1+i):n)=uk;     
	end
	
	% vytvoríme vektor sekvencí v rámci intervalu <0,1>
	u = linspace(0, 1, sekv); 
	
	k=zeros(size(u));
	s=zeros(size(u));
	
	% algoritmus
	% pre každú sekvenciu vypočítame jej multiplicitu v uzlovom vektore a index, kde sa v ňom nachádza
	
	for i=1:numel(u)  
	
		h=0;
		for j=1:(numel(U))
	
			% pokial sa nachádza sekvencia u(i) medzi U(j) a U(j+1) uzlami, jej multiplicita je nulová a uložíme si jej index
	
			if (U(j)<u(i)) && (U(j+1)>u(i))
				k(i)=j;
				s(i)=0;
	
				break; %nasli sme interval, v ktorom sa nachadza u(i)
				
				% pokial sa sekvencia rovná uzlu, spočítame jej multiplicitu a uložíme index prvého zhodného uzlu 
		
			elseif  u(i)==U(j)    
				k(i)=j;
				s(i)=s(i)+1;
			end
		end
	end
end
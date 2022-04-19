function [C]=deboor(P,p,U,k,s,u)
	m=size(P,1); %dimenzia  riadiacich bodov
	n=size(P,2); %pocet riadiacich bodov
	Pk = zeros(m,n,p);

	% algoritmus

	h=p-s;
	if h>0

        Pk(:, k-p:k-s, 1) = P(:, k-p:k-s); %vyberiem afektované body zo vstupných

		for r=2:(h+1)
			for j=(k-1-p+r):(k-s)
			
				a(j,r)=(u-U(j))/(U(j+p-r+1+1)-U(j));
				Pk(:,j,r)=(1-a(j,r))*Pk(:,j-1,r-1)+a(j,r)*Pk(:,j,r-1);                                   
			end
		end

		C = Pk(:,k-s,p-s+1);  % získaný bod na krivke

	elseif k == numel(U)  % posledný bod 
		C = P(:,end);
	else
		C = P(:,1);		% prvý bod 
	end
end
function phi = moments(Im)
%MOMENTS ber\"{a}knar Hu-momenten hos en bin\"{a}r bild
%
% Ber\"{a}knar Hu-momenten \cite{Hu62} s\aa{} som de definieras i
% kapitel \ref{sec:features} utifr\aa{}n den bin\"{a}ra bilden ''Im''.
%
% SYNOPSIS: phi = moments(Im)
%
% INPUT Im: bin\"{a}r bild f\"{o}r vilken Hu-momenten ska ber\"{a}knas
%
% OUTPUT phi: de sju f\"{o}rsta Hu-momenten f\"{o}r bilden ''Im''

% Bildens bredd och h\"{o}jd
width = size(Im,2);
height = size(Im,1);
% $4\times4$-matris f\"{o}r att lagra moment $M_{00}$ t.o.m. $M_{33}$
M = zeros(4);
% Matriser f\"{o}r ber\"{a}kning av de rena momenten
[K,L] = meshgrid(1:width, 1:height);
% Ber\"{a}kning av de rena momenten $M_{00}$ t.o.m. $M_{33}$
for i = 1:size(M,1)
    for j = 1:size(M,1)
        s = sum(sum(K.^(i-1).*L.^(j-1).*Im));
        M(i,j) = s;
    end
end
% Centroidens $x$- och $y$-koordinat
x_bar = M(2,1)/M(1,1);
y_bar = M(1,2)/M(1,1);
% Ber\"{a}kning av centralmomenten $\mu_{ij}$ och de skalningsinvarianta
% momenten $\eta_{ij}$
mu = zeros(4);
nu = zeros(size(mu));
for p = 1:size(mu,1)
    for q = 1:size(mu,1)
        s = 0;
        for m = 1:size(M,1)
            for n = 1:size(M,1)
                if(p >= m && q >= n)
                s = s + nchoosek(p-1,m-1)*nchoosek(q-1,n-1)*...
                    (-x_bar)^(p-m)*(-y_bar)^(q-n)*M(m,n);
                end
            end
        end
        mu(p,q) = s;
        gamma = (p+q)/2;
        nu(p,q) = mu(p,q)/(mu(1,1)^gamma);
    end
end
% Ber\"{a}kning av de faktiska Hu-momenten
phi = zeros(7,1);
phi(1) = nu(3,1) + nu(1,3);
phi(2) = (nu(3,1) + nu(1,3))^2 + 4*nu(2,2)^2;
phi(3) = (nu(4,1) - 3*nu(2,3))^2 + (3*nu(3,1) - nu(1,4))^2;
phi(4) = (nu(4,1) + nu(2,3))^2 + (nu(3,2) + nu(1,4))^2;
phi(5) = (nu(4,1) - 3*nu(2,3))*(nu(4,1) + nu(2,3))*...
         (3*(nu(4,1) + nu(2,3))^2 - 3*(nu(3,2) + ...
         nu(1,4))^2) + (3*nu(3,2) - nu(1,4))*(nu(3,2)...
         + nu(1,4))*(3*(nu(4,1) + nu(2,3))^2 - ...
         3*(nu(3,2) + nu(1,4))^2);
phi(6) = (nu(3,1) - nu(1,3))*((nu(4,1) + nu(2,3))^2 -...
         (nu(3,2) + nu(1,4))^2) + 4*nu(2,2)*(nu(4,1) +...
         nu(2,3))*(nu(3,2) + nu(3,2));
phi(7) = (3*nu(3,2) - nu(1,4))*(nu(4,1) + nu(2,3))*...
         ((nu(4,1) + nu(2,3))^2 - 3*(nu(3,2) + nu(1,4))^2)...
         - (nu(4,1) - 3*nu(2,3))*(nu(3,2) + nu(1,4)) ...
         *(3*(nu(4,1) + nu(2,3))^2 - 3*(nu(3,2) + nu(1,4))^2);
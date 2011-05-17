function skin = getskin(img, spm)
%GETSKIN klassificerar hud i en bild
%
% Funktionen anv\"{a}nder en fördefinierad SPM enligt
% kapitel \ref{sec:metod:hud:klass} för att identifiera hud i en $YC_bC_r$-bild.
%
% SYNOPSIS: skin = getskin(image, spm)
%
% INPUT image: $YC_bC_r$-bild hud skall hittas i
%         spm: Skin Probability Map
%
% OUTPUT skin: Bin\"{a}r bild d\"{a}r 1 representerar hud och 0
%              representerar ickehud.

% F\"{o}rallokera utdata
skin = zeros([size(img, 1) size(img, 2) 1]);
% Ineffektiv sökning i SPM f\"{o}r varje bildpunkt i indatan
for j=1:size(img, 1)
    for k=1:size(img, 2)
        skin(j,k) = spm(img(j,k,3), img(j,k,2));
    end
end

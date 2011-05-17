function hand = gethand(img, clip, reverse)
%GETHAND plockar ut objekted l\"{a}ngst till v\"{a}nster (handen)
%  
% Plockar ut objektet l\"{a}ngst till v\"{a}nster i bilden (dvs. handen,
% se kapitel \ref{sec:metod_hud:urskiljning}), eller l\"{a}ngst till h\"{o}ger om s\aa{} beg\"{a}rs.
% Indatan kan dessutom ''klippas'' f\"{o}r att spara ber\"{a}kningskraft.
%
% SYNOPSIS: hand = gethand(image, clip, reverse)
%
% INPUT image: Den bin\"{a}ra bild i vilken handen ska hittas
%        clip: Vektor av formatet [x y w h] som specificerar
%              ett omr\aa{}de i vilket funktionen ska s\"{o}ka
%     reverse: Funktionen letar fr\aa{}n h\"{o}ger om denna variabel \"{a}r
%              nollskild.
%
% OUTPUT hand: En bin\"{a}r bild som endast inneh\aa{}ller ett omr\aa{}de,
%              som kan anses vara handen i bilden ''image''

% Finns argumentet ''clip''? Om inte, definiera!
if(nargin < 2 || clip == []) clip = ...
  [1 1 size(img, 2) size(img, 1)]; end
x = clip(1); y = clip(2); w = clip(3); h = clip(4);
% \"{a}r ''reverse'' definierat?
if(nargin < 3) reverse = 0; end
% Ta bort sm\aa{} objekt i bilden (se \ref{sec:metod_hud:urskiljning})
img = bwareaopen(img, 200);

% Iterationsvariabler
from = x; to = x+w-1; step = 1;
if(reverse ~= 0) from = x+w-1; to = x; step = -1; end

% B\"{o}rja med att utg\aa{} ifr\aa{}n hela bilden
hand = img;
% Stega igenom varje kolumn och se om den inneh\aa{}ller en vit
% bildpunkt. G\"{o}r den det, s\aa{} v\"{a}lj det omr\aa{}de den tillh\"{o}r.
for j=from:step:to
    if max(img(y:(y+h-1),j) == 1)
        hand = bwselect(img, j, ...
               find(img(y:(y+h-1),j) == 1, 1));
        break
    end
end
% Om vi inte hittar en hand, leta i hela omr\aa{}det (ignorera ''clip'')
if(max(max(hand)) == 0) hand = gethand(img); end

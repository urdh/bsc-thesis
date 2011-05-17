function realtid()
%REALTID klassificerar gester i realtid
%
% SYNOPSIS: realtid()
%
% Denna funktion l\"{a}ser in video i realtid fr\aa{}n en kamera,
% identifierar handen och ber\"{a}knar egenskaper f\"{o}r var
% $n$:te bildruta. D\"{a}refter f\"{o}rs\"{o}ker funktionen m.h.a.
% \knn klassificera gesten i bildrutan.
%
% SEE ALSO: videofil

% ''\"{o}ppna'' kameran och st\"{a}ll in den p\aa{} $YC_bC_r$-l\"{a}ge
% Observera att f\"{o}rsta raden beror p\aa{} plattform, denna
% kod fungerar med den inbyggda kameran p\aa{} en MacBook Pro.
vid = videoinput('macvideo', 1, 'YCbCr422_1280x720');
set(vid,'ReturnedColorSpace','YCbCr');
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);
triggerconfig(vid, 'Manual');

% Starta videoinmatningen
start(vid);

% Importera externt lagrad data
SPM = importdata('skinprobmatrix2.mat'); % SPM (se \ref{sec:metod_hud:urskiljning})
normal = importdata('normal.mat'); % Normalisering (se \ref{sec:normering})

% Aktivera endast en del av egenskaperna
active = [2 3 4 5 6 8 9 10 11 15];
% V\"{a}lj l\"{a}mpligt $k$ till \knn
k = 7;

% Iterera \"{o}ver alla bildrutor i indata
for i=1:1000
    % Trigga inmatning av en ny bildruta
    trigger(vid);
    % L\"{a}s in och skala om en bildruta
    ycbcr = imresize(getdata(vid,1,'uint8'), 0.25);
    % \"{a}r det en bildruta vi ''hinner'' behandla?
    if mod(i,4) == 0
      % Hitta hud och hand i bilden
      hand = gethand(getskin(ycbcr, SPM));		
      % Ber\"{a}kna egenskaper
      feats = cell2mat(struct2cell(features(hand)))';		
      % Normalisera egenskaper
      feats = (feats - [normal(:).mu])./[normal(:).stddev];
      % Plocka ut aktiva egenskaper
      feats = feats(active);
      % Anv\"{a}nd \knn f\"{o}r att klassificera gesten
      [symb, dist] = getSymbol(feats, k, active);		
      % Visa den utplockade handen f\"{o}r anv\"{a}ndaren
      rgb = im2double(ycbcr2rgb(ycbcr));		
      rgb(:,:,1) = rgb(:,:,1).*hand;		
      rgb(:,:,2) = rgb(:,:,2).*hand;		
      rgb(:,:,3) = rgb(:,:,3).*hand;		
      imshow(rgb);		
      % Skriv ut vilken gest skriptet tror det var
      gester{symb}    
    end
end

% St\"{a}ng anslutningen till kameran
stop(vid); delete(vid);

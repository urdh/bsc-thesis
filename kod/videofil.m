function geststream = videofil(in_file)
%VIDEOFIL klassificerar gester i en videofil
%
% Denna funktion l\"{a}ser in en videofil, identifierar handen och
% ber\"{a}knar egenskaper f\"{o}r varje bildruta. D\"{a}refter f\"{o}rs\"{o}ker den
% klassificera gester i vajre bildruta m.h.a. \knn.
%
% SYNOPSIS: gester = videofil(filnamn)
%
% INPUT filnamn: Den videofil som ska behandlas
%
% OUTPUT gester: En vektor med en gestgissning per
%                bildruta i filmen.

% L\"{a}s in video fr\aa{}n filen
vid = VideoReader(in_file);    
nFrames = vid.NumberOfFrames();    

% Variabel f\"{o}r utdata
geststream = [];

% Importera externt lagrad data
SPM = importdata('skinprobmatrix2.mat'); % SPM (se \ref{sec:metod_hud:urskiljning})
normal = importdata('normal.mat'); % Normalisering (se \ref{sec:normering})

% Aktivera endast en del av egenskaperna
active = [2 3 4 5 6 8 9 10 11 15];
% V\"{a}lj l\"{a}mpligt $k$ till \knn
k = 7;

for i=1:nFrames
    % L\"{a}s in en bildruta och konvertera till $YC_bC_r$
    ycbcr = rgb2ycbcr(vid.read(1));
    % Identifiera hud och hand
    hand = gethand(getskin(rgb2ycbcr(rgb), SPM));
    % Ber\"{a}kna egenskaper
    feats = cell2mat(struct2cell(features(hand)))';
    % Normalisera egenskaper
    feats = (feats - normal(:).mu)/normal(:).stddev;
    % Plocka ut aktiva egenskaper
    feats = feats(active);
    % Anv\"{a}nd \knn f\"{o}r att klassificera gesten
    [symb, dist] = getSymbol(feats, k, active);   
    % L\"{a}gg till gestgissningen i utdatan
    geststream = [geststream; symb];
end

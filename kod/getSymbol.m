function [symbol, dist] = getSymbol(featv,k,active)
%GETSYMBOL klassificerar en gest med \knn
%
% Denna funktion klassificerar en gest utifr\aa{}n ett
% antal egenskaper med hj\"{a}lp av \knn-metoden. Den
% prototypm\"{a}ngd som anv\"{a}nds laddas automatisk in.
% Majority voting appliceras.
%
% SYNOPSIS: [gesture, dist] = getSymbol(feats, k, active)
%
% INPUT featv: Egenskaperna gesten klassificeras utifr\aa{}n
%           k: Antalet n\"{a}rmsta grannar
%      active: En vektor som ber\"{a}ttar vilka egenskaper som
%              tas h\"{a}nsyn till i prototypm\"{a}ngden
%
% OUTPUT gesture: Den klassificerade gesten
%           dist: Genomsnittligt grannavst\aa{}nd

% Ladda in prototypm\"{a}ngd
persistent book;
if isempty(book) book = importdata('protobook.mat'); end

% Leta upp de $k$ n\"{a}rmsta grannarna
[IDX, D] = knnsearch(book(:,active),featv,...
                     'K',k,'NSMethod','kdtree');
neighbours = book(IDX,end-1);

% Sortera stigande efter avst\aa{}nd
IDXD = [IDX;D]'; IDXD = sortrows(IDXD,2);

% Hitta den vanligaste grannen (majority voting)
[symbol, f, same_freq] = mode(neighbours);

% Kolla om vi har ''oavgjort''
while (size(same_freq{1},1) ~= 1)
    % Ta bort den yttersta grannen och f\"{o}rs\"{o}k igen
    IDXD = IDXD(1:(end-1),:);
    neighbours = book(IDXD(:,1),end-1);
    [symbol, f, same_freq] = mode(neighbours);
end

% Ber\"{a}kna det genomsnittliga avst\aa{}ndet  
dist = mean(IDXD(:,2));

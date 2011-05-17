function [A,B] = hmm_training(states,symbols,O)
%HMM_TRAINING tr\"{a}nar en dold Markovmodell
%
% Denna funktion tr\"{a}nar en dold Markovmodell med
% Bakis-metoden (se kapitel \ref{sec:hmm:train})
%
% SYNOPSIS: [A,B] = hmm_training(states, symbols, O)
%
% INPUT states: Antalet states modellen ska ha
%      symbols: Antalet symboler i kodboken
%            O: Matris av radvisa observationssekvenser
%
% OUTPUT A: \"{o}verg\aa{}ngsmatris f\"{o}r modellen
%        B: Sannolikheter f\"{o}r symboler

% Skapa en uniform LR-modell
A = zeros(states);
for i = 1:states
    for j = i:states
        A(i,j) = 1/(states + 1 - i);
    end
end

% Skapa en B-matris d\"{a}r alla element \"{a}r noll f\"{o}rutom
% de index som finns i O. 
obs = reshape(O,1,size(O,1)*size(O,2));
unique_obs = [];
% Hitta unika observationer i O
for i = 1:symbols
    if(find(obs == i) > 0)
        obs_pos = find(obs == i);
        unique_obs = [unique_obs, obs(obs_pos(1))];
    end
end

% Ber\"{a}kna sannolikheter f\"{o}r symboler
B = zeros(states,symbols);
for i = 1:states
    B(i,unique_obs) = 1/length(unique_obs);
end


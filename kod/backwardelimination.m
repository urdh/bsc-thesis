% Detta skript optimerar v\aa{}r \knn enligt kapitel \ref{sec:metod_knn:optim}.
% Algoritmen som anv\"{a}nds \"{a}r bak\aa{}teliminering

% Ladda testdata
load testbook; last = size(testbook,1);

% F\"{o}r resultat
best_active = {};
best_ratio=zeros(13,15);

% F\"{o}r varje $k$ vi vill testa
for k = 1:13
    % Skapa en full m\"{a}ngd $E$
    active = 1:15;
    % Komplementet till $E$
        
    for j = 1:15
        % Vi vill hitta l\"{a}gsta felration.
        % Initiera med $\infty$ f\"{o}r alla egenskaper!
        ratio = Inf*ones(1,15);
        % F\"{o}r alla \"{a}nnu aktiva egenskaper
        for t = active
            syms = [];
            % Klassificera gesten med alla
            % egenskaper utom en
            active_now=active;
            active_now(find(active==t)) = [];
            for i=1:last
                % H\"{a}mta det k\"{a}nda egenskapsv\"{a}rdet
                real_sym = testbook(i,end-1);
                % H\"{a}mta egenskapsvektorn
                featv = testbook(i,active_now);
                % Klassificera gesten
                [obs_sym, dist] = ...
                     getSymbol(featv,k,active_now);
                % Spara resultatet
                syms=[syms; real_sym obs_sym dist];
            end
            % Ber\"{a}kna andel fel
            n_fel = size(syms( syms(:,1) ~= syms(:,2) ),1);
            n_okej = size(syms( syms(:,1) == syms(:,2) ),1);
            ratio(t) = n_fel/(n_fel+n_okej);
        end
        % Hitta ''b\"{a}sta'' egenskapen och flytta ut ur $E$
        best_idx = find(min(ratio)==ratio,1);
        active(find(active==best_idx,1)) = [];
        best_ratio(k,15-j) = ratio(best_idx);
        best_active{k,15-j} = active;
    end
end
% Spara resultaten
save('best_ratio_bwd.mat','best_ratio');
save('best_active_bwd.mat','best_active');

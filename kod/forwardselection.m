% Detta skript optimerar v\aa{}r \knn enligt kapitel \ref{sec:metod_knn:optim}.
% Algoritmen som anv\"{a}nds \"{a}r fram\aa{}turval

% Ladda testdata
load testbook; last = size(testbook,1);

% F\"{o}r resultat
best_active = {};
best_ratio = zeros(13,15);

% F\"{o}r varje $k$ vi vill testa
for k = 1:13
    % Skapa tom m\"{a}ngd $E$
    active = [];
    % Komplementet till $E$
    nonactive = 1:15;
    
    for j = 1:15
        % Vi vill hitta l\"{a}gsta felration.
        % Initiera med $\infty$ f\"{o}r alla egenskaper!
        ratio = Inf*ones(1,15);
        % Alla egenskaper i komplementet till $E$ ska behandlas
        for t = nonactive
            syms = [];
            % F\"{o}r alla observationer, klassificera gesten
            for i=1:last
                % H\"{a}mta det k\"{a}nda gestv\"{a}rdet
                real_sym = testbook(i,end-1);
                % H\"{a}mta egenskapsvektorn
                featv = testbook(i,[active t]);
                % Klassificera gesten
                [obs_sym, dist] = ...
                     getSymbol(featv,k,[active t]);
                % Spara resultatet
                syms=[syms; real_sym obs_sym dist];
            end
            % Ber\"{a}kna andel fel
            n_fel = size(syms( syms(:,1) ~= syms(:,2) ),1);
            n_okej = size(syms( syms(:,1) == syms(:,2) ),1);
            ratio(t) = n_fel/(n_fel+n_okej);
        end
        % Hitta ''b\"{a}sta'' egenskapen och flytta in i $E$
        best_idx = find(min(ratio)==ratio,1);
        active = [active best_idx]
        nonactive(find(nonactive==best_idx,1)) = [];
        best_ratio(k,j) = ratio(best_idx);
        best_active{k,j} = active;
    end
end
% Spara resultaten
save('best_ratio_fwd.mat','best_ratio');
save('best_active_fwd.mat','best_active');

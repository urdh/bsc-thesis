function f = features(frame)
%FEATURES ber\"{a}knar egenskaper hos en bin\"{a}r bild
%
% Den h\"{a}r funktionen ber\"{a}knar femton egenskaper (av dessa n\"{a}mns
% n\aa{}gra i kapitel \ref{sec:features}) utifr\aa{}n en bin\"{a}r bild ''\texttt{frame}'' vilken
% antas inneh\aa{}lla ett enda sammanh\"{a}ngande objekt f\"{o}rest\"{a}llande en
% hand.
%
% SYNOPSIS: f = features(frame)
%
% INPUT frame: bin\"{a}r bild med ett sammanh\"{a}ngande objekt (en hand)
%
% OUTPUT f: struct inneh\aa{}llandes ett antal egenskaper

% Importera konstanter f\"{o}r normalisering av egenskaperna
norm = importdata('normal.mat');

% Ber\"{a}kna ett antal egenskaper m.h.a. funktionen \texttt{regionprops}
props = regionprops(this_frame, 'Area','Orientation',...
	'Perimeter','Centroid','Eccentricity','Extent',...
	'Solidity','ConvexImage','BoundingBox');
props = props(1);

% Kompakthet
f.Compactness = 4*pi*props.Area/(props.Perimeter)^2;
% Soliditet
f.Solidity = props.Solidity;
% Konvexitet
convex_props = regionprops(props.ConvexImage,'Perimeter');
f.Convexity = convex_props.Perimeter/props.Perimeter;
% Excentricitet
f.Eccentricity = props.Eccentricity;
% Utstr\"{a}ckning
f.Extent = props.Extent;
% Fyrkantighet
f.Squareness = props.BoundingBox(3)/props.BoundingBox(4);
% Centroidl\"{a}ge
f.CentroidBoxPosX = ( props.Centroid(1) - ...
 	props.BoundingBox(1) ) / props.BoundingBox(3);
f.CentroidBoxPosY = ( props.Centroid(2) - ...
	props.BoundingBox(2) ) / props.BoundingBox(4);
% Hu-moment (se bilaga \ref{sec:matlab:features})
phi = moments(this_frame);
f.Hu1 = phi(1);
f.Hu2 = phi(2);
f.Hu3 = phi(3);
f.Hu4 = phi(4);
f.Hu5 = phi(5);
f.Hu6 = phi(6);
f.Hu7 = phi(7);

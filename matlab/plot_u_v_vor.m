%
clc; close all; clear

load('surf_uv_vor_box_lon116_118_lat17_19.mat')

figure
% colormap(jet)
mypcolor(lonz,latz,squeeze(z(:,:,1200))');
% mypcolor(lonu,latu,squeeze(u(:,:,1200))');
% caxis([-0.8 0.8])
colorbar
xlim([116 118])
ylim([17 19])
title(['\zeta/f at the surface on ' datestr(tme(1))])

load('eta_box_lon116_118_lat17_19.mat')

% clf
figure
% colormap(jet)
mypcolor(lon,lat,squeeze(eta(:,:,1200))');
% caxis([-0.8 0.8])
colorbar
xlim([116 118])
ylim([17 19])
title(['\eta (m) at the surface on ' datestr(tme(1))])
axis tight


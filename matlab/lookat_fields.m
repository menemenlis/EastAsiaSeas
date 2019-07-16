% Replace line below with location of your root directory
cd ~/llc_4320/regions/SouthChinaSea3/matlab

% Size of domain
nx=1056;
ny=2080;
nz=90;
suf=['_' int2str(nx) 'x' int2str(ny)];

% Read horizontal grid information.
% (XC,YC) is longitude/latitude coordinates of centers of grid cells
% (XG,YG) is longitude/latitude coordinates of southwest corners
XC=readbin(['../grid/XC' suf],[nx ny]);
YC=readbin(['../grid/YC' suf],[nx ny]);
XG=readbin(['../grid/XG' suf],[nx ny]);
YG=readbin(['../grid/YG' suf],[nx ny]);
hFacC=readbin(['../grid/hFacC' suf 'x90'],[nx ny]);

% Read vertical grid information.
load ../grid/thk90
dpt=dpt90(1:nz);   % depth of vertical level in m
thk=thk90(1:nz);   % thickness of vertical level in m
clear *90

% The model output is hourly, one file per hour.
% The first 10 digits of filename denote the model
% time step (ts), and I give example below how to
% convert time step to a date (dte).
ts=259920;
dte=ts2dte(ts,25,2011,9,10);

% Example of reading and plotting of level k
% of potential temperature Theta
k=1;
fnm=['../Theta/' myint2str(ts,10) '_Theta_6865.8180.1_1056.2080.90'];
fld=readbin(fnm,[nx ny],1,'real*4',k-1); % !!!
fld(find(hFacC==0))=nan;
clf
colormap(jet)
pcolorcen(XC',YC',fld');
caxis([5 30])
grid on
colorbar
title(['Theta (deg C) at ' int2str(dpt(k)) ' m depth on ' dte])
print -djpeg SST

% Example of reading and plotting sea ice effective thickness
% for ts=10368:144:1492992;
for ts=288720:(144*24):1492992;
    dte=ts2dte(ts,25,2011,9,10);
    fnm=['../SIheff/' myint2str(ts,10) '_SIheff_6865.8180.1_1056.2080.1'];
    fld=readbin(fnm,[nx ny]);
    if mmax(fld)>0
        fld(find(hFacC==0))=nan;
        clf
        colormap(jet)
        pcolorcen(XC',YC',fld');
        grid on
        colorbar
        title(['SIheff (m) on ' dte ' (' num2str(mmax(fld)) ')'])
        pause(.01)
    else
        disp(dte)
    end
end

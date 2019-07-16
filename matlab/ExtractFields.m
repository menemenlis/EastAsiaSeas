% South China Sea region for Zhiyu Liu,
% Hongyang Lin, and Qiang Dean on June 2019
% extract 13-Sep-2011 to 15-Nov-2012
% lats 5N to 30N, lons 105E to 125E
% (example extraction on face 1 or face 2)

% define desired region
nx=4320;
prec='real*4';
region_name='SouthChinaSea3';
minlat=5;
maxlat=40.94;
minlon=105;
maxlon=127;
mints=dte2ts('13-Sep-2011',25,2011,9,10);
maxts=dte2ts('15-Nov-2012',25,2011,9,10);

% extract indices for desired region
gdir='~dmenemen/llc_4320/grid/';
fnam=[gdir 'Depth.data'];
[fld fc ix jx] = ...
    quikread_llc(fnam,nx,1,prec,gdir,minlat,maxlat,minlon,maxlon);
clf,quikpcolor(fld'),caxis([0 1])
load ~dmenemen/llc_4320/grid/thk90.mat
bot90=dpt90+thk90/2;
kx=1:min(find((bot90+.0001)>=mmax(fld)));

% Get and save grid information
close all
pin='~dmenemen/llc_4320/grid/';
pout=['~dmenemen/llc_4320/regions/' region_name '/grid/'];
eval(['mkdir ' pout])
eval(['cd ' pout])
suf1=['_' int2str(length(ix)) 'x' int2str(length(jx))];
suf2=[suf1 'x' int2str(length(kx))];
for fnm={'Depth','RAC','XC','YC','hFacC','XG','YG', ...
         'RAZ','DXC','DYC','DXV','DYU','DXG','DYG'}
    fin=[pin fnm{1} '.data'];
    switch fnm{1}
      case{'hFacC'}
        fld=read_llc_fkij(fin,nx,fc,kx,ix,jx);
        fout=[fnm{1} suf2];
      otherwise
        fld=read_llc_fkij(fin,nx,fc,1,ix,jx);
        fout=[fnm{1} suf1];
    end
    writebin(fout,fld);
end

% create commands for extracting model output fields
pout=['~dmenemen/llc_4320/regions/' region_name '/'];
extract='/home4/bcnelson/MITgcm/extract/latest/extract4320 -g ';
timesteps=[int2str(mints) '-' int2str(maxts) ' '];
startPoint=[int2str((fc-1)*nx+min(ix)) ',' int2str(min(jx)) ',1 '];

% get and save regional 2D fields
extent=[int2str(length(ix)) ',' int2str(length(jx)) ',1'];
for fnm={'Eta','PhiBot','KPPhbl','oceFWflx','oceQnet','oceQsw','SIheff'}
    eval(['mkdir ' pout fnm{1}])
    eval(['cd ' pout fnm{1}])
    fieldNames=[fnm{1} ' '];
    system([extract timesteps  fieldNames  startPoint  extent '  > joblist']);
    disp(['cd ' pout fnm{1}])
    disp('parallel --slf $PBS_NODEFILE -j2 -a joblist')
end

% Get and save regional 3D fields
extent=[int2str(length(ix)) ',' int2str(length(jx)) ',' int2str(kx(end))];
for fnm={'Salt','Theta','U','V','W'}
    eval(['mkdir ' pout fnm{1}])
    eval(['cd ' pout fnm{1}])
    fieldNames=[fnm{1} ' '];
    system([extract timesteps  fieldNames  startPoint  extent '  > joblist']);
    disp(['cd ' pout fnm{1}])
    disp('parallel --slf $PBS_NODEFILE -j2 -a joblist')
end

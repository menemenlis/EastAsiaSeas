%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Build runtime input files needed to run a sub-region of llc_4320,

% {{{ Define desired region and initialize some variables 
NX=4320;
prec='real*4';
region_name='SouthChinaSea3';
minlat=5;
maxlat=40.94;
minlon=105;
maxlon=127;
mints=dte2ts('13-Sep-2011',25,2011,9,10);
maxts=dte2ts('15-Nov-2012',25,2011,9,10);
pout=['~dmenemen/llc_4320/regions/' region_name '/run_template/'];
eval(['mkdir ' pout])
eval(['cd ' pout])
gdir='~dmenemen/llc_4320/grid/';
% }}}

% {{{ Extract indices for desired region 
gdir='~dmenemen/llc_4320/grid/';
fnam=[gdir 'Depth.data'];
[fld fc ix jx] = ...
    quikread_llc(fnam,NX,1,prec,gdir,minlat,maxlat,minlon,maxlon);
quikpcolor(fld')
[nx ny]=size(fld);
load ~dmenemen/llc_4320/grid/thk90.mat
bot90=dpt90+thk90/2;
kx=1:min(find((bot90+.0001)>=mmax(fld)));
nz=length(kx);
mypcolor(fld')
colorbar
% }}}

% {{{ Make bathymetry file 
close all
suf=['_' int2str(nx) 'x' int2str(ny)];
writebin([pout 'BATHY' suf  '_' region_name],-fld);
% }}}

% {{{ Create grid information files 
% {{{ LONC
fin=[gdir 'XC.data'];
fout=[pout 'LONC.bin'];
fld=read_llc_fkij(fin,NX,fc,1,ix,jx);
writebin(fout,fld);
% }}}
% {{{ LATC
fin=[gdir 'YC.data'];
fout=[pout 'LATC.bin'];
fld=read_llc_fkij(fin,NX,fc,1,ix,jx);
writebin(fout,fld);
% }}}
% {{{ DXF and DYF
finx =[gdir 'DXF.data']; finy =[gdir 'DYF.data'];
foutx=[pout 'DXF.bin' ]; fouty=[pout 'DYF.bin' ];
fldx=read_llc_fkij(finy,NX,fc,1,ix,jx);
fldy=read_llc_fkij(finx,NX,fc,1,ix,jx);
writebin(foutx,fldx);
writebin(fouty,fldy);
% }}}
% {{{ RA
fin=[gdir 'RAC.data'];
fout=[pout 'RA.bin'];
fld=read_llc_fkij(fin,NX,fc,1,ix,jx);
writebin(fout,fld);
% }}}
% {{{ LONG
fin=[gdir 'XG.data'];
fout=[pout 'LONG.bin'];
fld=read_llc_fkij(fin,NX,fc,1,ix,jx-1); % <<<<<<<<
writebin(fout,fld);
% }}}
% {{{ LATG
fin=[gdir 'YG.data'];
fout=[pout 'LATG.bin'];
fld=read_llc_fkij(fin,NX,fc,1,ix,jx-1); % <<<<<<<<
writebin(fout,fld);
% }}}
% {{{ DXV and DYU
finx =[gdir 'DXV.data']; finy =[gdir 'DYU.data'];
foutx=[pout 'DXV.bin' ]; fouty=[pout 'DYU.bin' ];
fldx =read_llc_fkij(finy,NX,fc,1,ix,jx-1); % <<<<<<<<
fldy =read_llc_fkij(finx,NX,fc,1,ix,jx-1); % <<<<<<<<
writebin(foutx,fldx);
writebin(fouty,fldy);
% }}}
% {{{ RAZ
fin=[gdir 'RAZ.data'];
fout=[pout 'RAZ.bin'];
fld=read_llc_fkij(fin,NX,fc,1,ix,jx-1); % <<<<<<<<
writebin(fout,fld);
% }}}
% {{{ DXC and DYC
finx =[gdir 'DXC.data']; finy =[gdir 'DYC.data'];
foutx=[pout 'DXC.bin' ]; fouty=[pout 'DYC.bin' ];
fldx =read_llc_fkij(finy,NX,fc,1,ix,jx);
fldy =read_llc_fkij(finx,NX,fc,1,ix,jx-1); % <<<<<<<<
writebin(foutx,fldx);
writebin(fouty,fldy);
% }}}
% {{{ RAW
fin=[gdir 'RAW.data'];
fout=[pout 'RAW.bin'];
fld=read_llc_fkij(fin,NX,fc,1,ix,jx);
writebin(fout,fld);
% }}}
% {{{ RAS
fin=[gdir 'RAS.data'];
fout=[pout 'RAS.bin'];
fld=read_llc_fkij(fin,NX,fc,1,ix,jx-1); % <<<<<<<<
writebin(fout,fld);
% }}}
% {{{ DXG and DYG
finx =[gdir 'DXG.data']; finy =[gdir 'DYG.data'];
foutx=[pout 'DXG.bin' ]; fouty=[pout 'DYG.bin' ];
fldx =read_llc_fkij(finy,NX,fc,1,ix,jx-1); % <<<<<<<<
fldy =read_llc_fkij(finx,NX,fc,1,ix,jx);
writebin(foutx,fldx);
writebin(fouty,fldy);
% }}}
% }}}

% {{{ Generate initial conditions 
sts=myint2str(mints,10);
suf='_6865.8180.1_1056.2080.1';
eval(['!cp ../Eta/' sts '_Eta' suf ' .']);
suf='_6865.8180.1_1056.2080.90';
for fld={'Theta','Salt','U','V'}
    eval(['!cp ../' fld{1} '/' sts '_' fld{1} suf ' .']);
end
% }}}

% {{{ Generate U/V/T/S lateral boundary conditions
fld={'Eta'};
pnm=['../' fld{1} '/'];
fnm=dir([pnm '*' fld{1} '*']);
for t=1:length(fnm)
    fin=[pnm fnm(t).name];
    tmp=readbin(fin,[nx ny]);
    fout=[fld{1} '_West']; % eastern boundary condition
    writebin(fout,squeeze(tmp(1,:)),1,prec,t-1)
    fout=[fld{1} '_East']; % western boundary condition
    writebin(fout,squeeze(tmp(end,:)),1,prec,t-1)
    fout=[fld{1} '_South']; % southern boundary condition
    writebin(fout,squeeze(tmp(:,1)),1,prec,t-1)
    %fout=[fld{1} '_North']; % northern boundary condition
    %writebin(fout,squeeze(tmp(:,end)),1,prec,t-1)
end
for fld={'Theta','Salt','U','V'}
    pnm=['../' fld{1} '/'];
    fnm=dir([pnm '*' fld{1} '*']);
    for t=1:length(fnm)
        fin=[pnm fnm(t).name];
        tmp=readbin(fin,[nx ny nz]);
        fout=[fld{1} '_West']; % eastern boundary condition
        if fld{1}=='U'
            writebin(fout,squeeze(tmp(2,:,:)),1,prec,t-1)
        else
            writebin(fout,squeeze(tmp(1,:,:)),1,prec,t-1)
        end
        fout=[fld{1} '_East']; % western boundary condition
        writebin(fout,squeeze(tmp(end,:,:)),1,prec,t-1)
        fout=[fld{1} '_South']; % southern boundary condition
        if fld{1}=='V'
            writebin(fout,squeeze(tmp(:,2,:)),1,prec,t-1)
        else
            writebin(fout,squeeze(tmp(:,1,:)),1,prec,t-1)
        end
        %fout=[fld{1} '_North']; % northern boundary condition
        %writebin(fout,squeeze(tmp(:,end,:)),1,prec,t-1)
    end
end
% }}}

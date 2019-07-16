%
clear; close all; clc; 

load Theta_mooring_lon117_lat18.mat

vv = size(Theta);

for i = 1:vv(2)
    theta_bar(i) = mean(Theta(:,i));
    theta_prime(:,i) = Theta(:,i)-theta_bar(i);
end

figure
subplot(1,2,1)
plot(Theta,-depth)
ylim([-100 0])
xlabel('\theta (\circC)')
ylabel('Depth (m)')

subplot(1,2,2)
plot(Theta,-depth)
ylim([-inf -100])
xlabel('\theta (\circC)')
ylabel('Depth (m)')

% calculate gradient of mean Theta profile
dtheta = theta_bar(2:end)-theta_bar(1:end-1);
dz = depth(2:end)-depth(1:end-1);
theta_bar_z = -dtheta./dz;
depthz = 0.5*(depth(1:end-1)+depth(2:end));

% figure
% subplot(1,2,1)
% plot(theta_bar_z,-depthz)

theta_bar_z = interp1(depthz,theta_bar_z,depth,'linear','extrap');
% hold on
% plot(theta_bar_z,-depth,'r-')
% hold off

% calculate eta at each depth...
% theta_bar_z = theta_bar_z'*ones(1,vv(2));
% eta = theta_prime*(1./theta_bar_z');
for i =1:vv(1)
    eta(i,:) = theta_prime(i,:)'./theta_bar_z';
    
end

figure
imagesc(tme,-depth(20:end-10),eta(:,20:end-10)')
colormap('jet')
caxis([-60 60])
colorbar
datetick('x')
set(gca,'ydir','normal')
% figure
% clf
% subplot(1,2,1)
% plot(theta_bar,-depth,'b-*')
% xlabel('\theta (\circC)')
% ylabel('Depth (m)')

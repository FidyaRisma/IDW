dtrf=[1 293721 2750080 25.2;
2 273748 2742683 33.1;
3 298725 2727845 38.5;
4 290411 2719273 62.3;
5 289587 2729063 50.8;
6 287977 2736069 41.3;
7 284322 2742290 30.2];


X = dtrf(:,2);
Y = dtrf(:,3);
Z = dtrf(:,4);

[Mask, Rma] = readgeoraster('mask_raster.tif');
Inf_mask = geotiffinfo('mask_raster.tif');
Mask = double(Mask);
Nodata_v = min(min(Mask)); 

% Get cellsize of Mask
Dyma = Rma.CellExtentInWorldY;
Dxma = Rma.CellExtentInWorldX;

YTop=max(Y)-Dyma/2; 
YBottom=min(Y)+Dyma/2;
XRight=max(X)-Dxma/2;
XLeft=min(X)+Dxma/2; 
Y1= YTop:-Dyma:YBottom;
X1= XLeft:Dxma:XRight;

Y2=sort(Y1,'descend');
% Create a mesh grid with cellsize of mask
[Xq,Yq] = meshgrid(X1,Y2);
% Define Raster 
nrows = length(Y1);
ncols = length(X1);


Rin.CellExtentInWorldY = Dyma;
Rin.CellExtentInWorldX = Dxma;
Rin.RasterSize = [nrows ncols];  
Rin.YWorldLimits = [YBottom YTop];
Rin.XWorldLimits = [XLeft XRight];


%% Station Location

n=length(Z);
for  r=1:n
X12=abs(X1-X(r));
A1(r,:)=(find(X12==min(abs(X1-X(r))),1,'first'));
Y12=abs(Y2-Y(r));
A2(r,:)=(find(Y12==min(abs(Y2-Y(r))),1,'first'));
end


%% IDW
% Interpolation
nrows = length(Y1);
ncols = length(X1);

for ii = 1:nrows
for jj = 1:ncols
[Z0_idw1(ii,jj)] = idw_int1(X,Y,Z,Xq(ii,jj),Yq(ii,jj),2);
end
end

[Mask, Rma] = readgeoraster('mask_raster.tif');
Extract=RasterClip1(Z0_idw1,Rin,Mask,Rma,Nodata_v);

%% 

figure
subplot(1,3,1)
imagesc(Z0_idw1);
caxis([20 60]);
cmap= cbrewer2('RdYlBu',40);
colormap(cmap)
hold on
plot(A1,A2,'g','Marker','diamond','MarkerFaceColor','g','LineStyle','none','MarkerEdgeColor','k');
legend('Rainfall Station Location Estimation','Location','southoutside');
title('Rainfall IDW Interpolation Unmasked');
colorbar;
subplot(1,3,2);
imagesc(Mask,'AlphaData',Mask==1);
title('Mask');
subplot(1,3,3)
imagesc(Extract,'AlphaData',Extract~=-9999);
caxis([20 60]);
cmap= cbrewer2('RdYlBu',40);
colormap(cmap)
title('Rainfall IDW Interpolation');
colorbar;






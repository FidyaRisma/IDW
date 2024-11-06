function Z0 = IDW(X,Y,Z,Xq,Yq,d)

[m,n] = size(Xq);
for ii = 1:m
for jj = 1:n
dist(ii,jj) = sqrt((Xq(ii,jj)-X).^2+(Yq(ii,jj)-Y).^d);
ZD(ii,jj) = sum(Z.*(1./(dist(ii,jj).^2)));
D(ii,jj) = sum(1./(dist(ii,jj).^2));
Z0(ii,jj) = ZD./D;
end
end
end
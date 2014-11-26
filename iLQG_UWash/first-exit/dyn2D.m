function [f,fx,fu,fxx,fxu,fuu] = dyn2D(x,u,dt)

N     = size(x,2);

f     = x + dt*[x(2,:); -sum(x.^3,1)/6 + u];


if nargout > 1

   fx          = repmat(eye(2),[1 1 N]);
   fx(1,2,:)   = dt;
   fx(2,:,:)   = fx(2,:,:)-dt*permute(x.^2/2,[3 1 2]);

   fxx         = repmat(permute(cat(3,zeros(2),eye(2)),[3 2 1]),[1 1 1 N]);
   fxx(fxx~=0) = -dt*x;

   fxu         = zeros(2,2,1,N);

   fu          = zeros(2,1,N);
   fu(2,:,:)   = dt;
   
   fuu         = zeros(2,1,1,N);
   
end
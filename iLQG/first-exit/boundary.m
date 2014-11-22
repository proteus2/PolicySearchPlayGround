function [y,g,H] = boundary(x)

a = 3;
b = 1;

s  = sign(x);
z  = abs(x);
sz = sum(z.^a,1);

y  = sz.^b - .3.^b;

if nargout > 1

   g  = b*a*s.*(z.^(a-1)) .* ([1;1]*sz.^(b-1));

   if nargout > 2
      H = a^2*(s.*z.^(a-1))*(s.*z.^(a-1))' * b*(b-1)*sz.^(b-2) +...
          a*(a-1) * diag(z.^(a-2)) * b*sz.^(b-1);
   end
end
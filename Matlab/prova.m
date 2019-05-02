N=8;
n = (0:N-1)';
f = 0.05;
W = exp(j*2*pi*f*n);

U = (W*W').*(n-n');

if 0 
  % sanity check 
  W2 = exp(j*2*pi*(f+0.00005)*n);
  Q = 20000*((W2*W2')-(W*W'));
  angle(Q./(j*2*pi*U)) / pi
end


[A, D]=eig(U);
			      % here U = A*D*A'
			      % I am searching for vectors h such that
			      %
			      %    h'*U*h=h'*A*D*A'*h = g'*D*g = 0
			      %
			      % where g=A'*h. Since U is
			      % skew-hermitian (that is, U' = - U) we
			      % know that the eigenvalues of U are
			      %
			      % (i) immaginary and pair-opposite or
			      % (ii) zero
			      %
			      % Note that
			      %
			      % g'*D*g = \sum_k |g_k|^2 \lambda_k
			      %
			      % Suppose wlg that the first 2K
			      % eigenvalues are not zero and that
			      % consecutive eigenvalues are
			      % opposite. It follows that g_k 
			      % for k > K can be arbitrary while it
			      % must be
			      %
			      %    |g_{2n}| = |g_{2n-1}| n<= K
			      %
			      % A sufficient (but not necessary)
			      % condition for equality above is
			      %
			      %  g_{2n} = g_{2n-1}
			      %
			      % Therefore, g must belong to the space
			      % generated by K vectors with two "1"
			      % and N-2K vectors from the identity
			      % matrix.  Call C this basis matrix.  It
			      % follows that it must be
			      %
			      %   h \in Im(A*C)


[D, idx]=sort(abs(diag(D))); % Sort the eigenvalues in increasing
			     % order

A=A(:, idx);  % Adjust A 

idx = max(find(D < 1e-6))

if mod(N-idx, 2) == 1
  error('N-idx pari')
end

blk_zero = eye(idx);
blk_pair = kron(eye((N-idx)/2), [1;1]);
C = blkdiag(blk_zero, blk_pair);
B = A*C;

% Now, I want that W'*h = 1, that is, W'*A*C*u = W'*B*u = 1.  This is
% true if u=u0+v, where W'*B*u0=1 and v \in null(W'*B).  A suitable
% choice for u0 can be B'*W suitably scaled.  In other words, I need
% to searech over
%
%   h = B*(u0 + K*s)   where K=null(W'*B), s \in \complessi^L
%     = B*u0 + B*K*s   

u0 = B'*W;
u0 = u0 / (W'*B*u0);
K = null(W'*B);

h0 = B*u0;
H  = B*K;


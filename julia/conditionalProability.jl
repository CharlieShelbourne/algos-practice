prior = ones(6,6);

uniform_prior = prior / 36;

likelyhood = zeros(6,6);

#p(t=9|sa,sb)
likelyhood[3,6] = 1;
likelyhood[4,5] = 1;
likelyhood[5,4] = 1;
likelyhood[6,3] = 1;

model = likelyhood .* uniform_prior

#p(sa,sb|t=9) = p(t=9|sa,sb)p(sa)p(sb)/s(t=9)
#p(p=t) = 4/36 = 1/9


model = model / (1/9)


# Quantile mapping of stochastic paths to target distribution

# We want to transform a collection of stochastic paths such that their
# marginal distribution at time h follows a pre-specified target
# distribution. We achieve that by mapping the quantiles of any original
# paths to the corresponding quantile of the target distribution.

# Simulate random walk with drift ---------------------------------

N = 250  # number of series
H = 100   # length of series
init = 0  # initial series value
drift = 0.2 # ar drift

# innovations
E <- matrix(0, nrow = H, ncol = N)
for (n in 1:N) {
  E[,n] <- rnorm(H)
}
# matrix of stochastic paths
X <- matrix(0, nrow = H, ncol = N)
X[1,] <- init
for (n in 1:N) {
  for (h in 2:H) {
    X[h,n] = X[h-1,n] + drift + E[h-1,n]
  }
}
# plot stochastic paths
plot(x = 1:H, y = X[,1], type = 'l', col = rgb(0, 0, 0, alpha = 0.1), ylim = c(-25, 25))
for (n in 2:N) {
  lines(x = 1:H, y = X[,n], col = rgb(0, 0, 0, alpha = 0.1))
}

# Map the paths to the target distribution ------------------------

X_adj <- matrix(0, nrow = H, ncol = N)
X_ECDF <- apply(X, 1, ecdf)
for (n in 1:N) {
  for (h in 1:H) {
    # the empirical quantile of the path value at h
    q <- X_ECDF[[h]](X[h,n])
    # the corresponding quantile of the target distribution
    # here we choose the Normal distribution with seasonaly changing sigma
    # and same drift as original paths
    X_adj[h,n] <- qnorm(q, mean = 0.2*h, sd = exp(sin(h/4))*10)
  }
}
plot(x = 1:H, y = X[,1], type = 'l', col = rgb(0, 0, 0), ylim = c(-50, 50))
lines(x = 1:H, y = X_adj[,1], col = rgb(1, 0, 0))
for (n in 2:N) {
  lines(x = 1:H, y = X[,n], col = rgb(0, 0, 0, alpha = 0.1))
}
for (n in 2:N) {
  lines(x = 1:H, y = X_adj[,n], col = rgb(1, 0, 0, alpha = 0.1))
}

using Plots, LaTeXStrings         # used to visualize the result
using SpecialFunctions: gamma     # used to define the gamma pdf
using Optim: maximize, maximizer  # used to find x₀
using ForwardDiff: derivative     # used to find h''(x₀)
default(fill=true, fillalpha=0.3, xlabel="λ") # plot defaults

Normal(μ, σ²) = x -> (1/(sqrt(2π*σ²))) * exp(-(x-μ)^2/(2*σ²))
Poisson(Y::Int) = λ -> (λ^Y) / factorial(Y) * exp(-λ)
Gamma(α, θ) = λ -> (λ^(α-1) * exp(-λ/θ)) / (θ^(α) * gamma(α))

prior = Gamma(3, 3)
likelihood(Y) = Poisson(Y)
joint_log_likelihood(Y) = λ -> log(likelihood(Y)(λ) * prior(λ))

y = 2
exact_posterior = Gamma(prior.α + y, prior.θ / (prior.θ + 1))

λ = range(0, 12, length=500)
plt = plot(λ, prior, lab=L"p(\lambda)")
plot!(λ, exact_posterior, lab=L"p(\lambda|D)")
# savefig(plt, joinpath(@__DIR__, "1-prior-and-exact-exact_posterior.svg"))
# savefig(plt, joinpath(@__DIR__, "1-prior-and-exact-exact_posterior.png"))

λ₀ = maximize(joint_log_likelihood(y), first(λ), last(λ)) |> maximizer

hꜛꜛ(λ) = derivative(λ -> derivative(joint_log_likelihood(y), λ), λ)

laplace_approx = Normal(λ₀, -(hꜛꜛ(λ₀))^(-1))

plot!(λ, laplace_approx, lab=L"p_{\mathcal{L}}(\lambda|D)", title=L"\textrm{Laplace~approximation}")

# savefig(plt, joinpath(@__DIR__, "2-laplace-approximation.png"))

# plot!(xlab="", ylab="", framestyle=:none, leg=false, title="", size=(1000,420))
# savefig(plt, joinpath(@__DIR__, "cover-image.png"))

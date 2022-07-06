using Plots, LaTeXStrings         # used to visualize the result
using Optim: maximize, maximizer  # used to find x₀
using ForwardDiff: derivative     # used to find h''(x₀)

f(x) = (4-x^2)*exp(-x^2)

x = range(-2, 2, length=100)
x₀ = maximize(x -> f(x), first(x), last(x)) |> maximizer

h(x) = log(f(x))
hꜛꜛ(x) = derivative(x -> derivative(h, x), x) # second derivative

q(x) = f(x₀) * exp((1/2) * hꜛꜛ(x₀) * (x-x₀)^2) # Laplace approximation

plt = plot( x, f, lab=L"f(x)= (4-x^2) \cdot e^{-x^2}", xlab=L"x", title=L"\textrm{Laplace~approximation}")
plot!(x, q, lab=L"q(x) = %$(f(x₀)) \cdot e^{\frac{%$(hꜛꜛ(x₀))}{2} x^2}")
sticks!([x₀], [f(x₀)], m=:circle, lab="")

# savefig(plt, joinpath(@__DIR__, "laplace-approximation.png"))

# plot!(xlabel="", lab="", framestyle=:none, leg=false, title="", size=(1000,420))
# savefig(plt, joinpath(@__DIR__, "cover-image.png"))

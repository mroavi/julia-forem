using Plots, LaTeXStrings, Printf, Distributions
pyplot(f=true, fa=0.3, grid=false, xticks=false, size=(600, 400),
       legend=false, xlabel=L"\theta", ylabel=L"P(\theta)",
       fontfamily="CMU Serif", yformatter=y->@sprintf("%.1E",y))

θ = range(-10, 10, length=500)

d1 = pdf.(Normal(-5, 1), θ)
d2 = pdf.(Normal(5, sqrt(2)), θ)

p1 = plot(d1, yticks=[maximum(d1)])      # top
p2 = plot(d2, yticks=[maximum(d2)], c=2) # middle

ymaxr = [0.4/i^4.5 for i=1:50] |> x->vcat(x,repeat([last(x)],20))

anim = @animate for ymax in ymaxr
  p3 = plot(d1)                          # bottom
  plot!(d2)
  plot!(d1 .* d2, yticks=[ymax*0.97], ylims=(0,ymax))
  plot(p1, p2, p3, layout=(3,1))         # all
end

gif(anim, joinpath(@__DIR__, "anim.gif"), fps=10)

# plot(p1, p2, layout=(2,1))
# savefig(joinpath(@__DIR__, "operands.png"))

# p3 = plot(d1, yticks=[maximum(d1)])      # top
# plot!(d2, c=2)                           # middle
# plot!(d1 .* d2,)                         # bottom
# plot(p1, p2, p3, layout=(3,1))           # all
# savefig(joinpath(@__DIR__, "first-frame.png"))

# plot(p1, p2, layout=(2,1), xlab="", ylab="", framestyle=:none, leg=false, title="", size=(1000,420))
# savefig(joinpath(@__DIR__, "cover-image.png"))

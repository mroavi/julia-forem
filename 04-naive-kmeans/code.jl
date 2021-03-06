using Plots, RDatasets, Distances, Statistics
pyplot(leg=false, ms=6, border=true, fontfamily="Calibri",
       title="NaΓ―ve k-means")             # plot defaults
iris = dataset("datasets", "iris");       # load dataset
π±β = collect(Matrix(iris[:, 1:2])');      # select features
K = 3                                     # number of clusters

function plot_clusters(π±β, πβ, kβ)
  plt = scatter(π±β[1,:], π±β[2,:], c=kβ)
  scatter!(πβ[1,:], πβ[2,:], m=(:xcross,10), c=1:size(πβ,2))
  return plt
end

# Initialize the means for each cluster
πβ = π±β[:, rand(axes(π±β, 2), K)]

anim = @animate for _ in 1:15

  # Find the squared distance from each sample to each mean
  d = pairwise(SqEuclidean(), π±β, πβ, dims=2)

  # 1. Assign each point to the cluster with the nearest mean
  kβ = findmin(d, dims=2)[2] |> x -> map(i -> i.I[2], x)

  # 2. Update the cluster means
  for k in 1:K
    π±ββ = π±β[:, dropdims((kβ .== k), dims=2)]
    πβ[:, k] = mean(π±ββ, dims=2)
  end

  plot_clusters(π±β, πβ, kβ)

end

gif(anim, joinpath(@__DIR__, "anim.gif"), fps=2)

# # Cover image
# plt = plot(xlabel="", lab="", framestyle=:none, leg=false, title="", size=(1000,420))
# kβ = findmin(d, dims=2)[2] |> x -> map(i -> i.I[2], x)
# scatter!(π±β[1,:], π±β[2,:], color=kβ)
# scatter!(πβ[1,:], πβ[2,:], m=(:xcross,10), color=1:K)
# savefig(plt, joinpath(@__DIR__, "cover-image.png"))

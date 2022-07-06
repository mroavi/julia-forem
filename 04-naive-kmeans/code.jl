using Plots, RDatasets, Distances, Statistics
pyplot(leg=false, ms=6, border=true, fontfamily="Calibri",
       title="Naïve k-means")             # plot defaults
iris = dataset("datasets", "iris");       # load dataset
𝐱ₙ = collect(Matrix(iris[:, 1:2])');      # select features
K = 3                                     # number of clusters

function plot_clusters(𝐱ₙ, 𝛍ₖ, kₙ)
  plt = scatter(𝐱ₙ[1,:], 𝐱ₙ[2,:], c=kₙ)
  scatter!(𝛍ₖ[1,:], 𝛍ₖ[2,:], m=(:xcross,10), c=1:size(𝛍ₖ,2))
  return plt
end

# Initialize the means for each cluster
𝛍ₖ = 𝐱ₙ[:, rand(axes(𝐱ₙ, 2), K)]

anim = @animate for _ in 1:15

  # Find the squared distance from each sample to each mean
  d = pairwise(SqEuclidean(), 𝐱ₙ, 𝛍ₖ, dims=2)

  # 1. Assign each point to the cluster with the nearest mean
  kₙ = findmin(d, dims=2)[2] |> x -> map(i -> i.I[2], x)

  # 2. Update the cluster means
  for k in 1:K
    𝐱ₙₖ = 𝐱ₙ[:, dropdims((kₙ .== k), dims=2)]
    𝛍ₖ[:, k] = mean(𝐱ₙₖ, dims=2)
  end

  plot_clusters(𝐱ₙ, 𝛍ₖ, kₙ)

end

gif(anim, joinpath(@__DIR__, "anim.gif"), fps=2)

# # Cover image
# plt = plot(xlabel="", lab="", framestyle=:none, leg=false, title="", size=(1000,420))
# kₙ = findmin(d, dims=2)[2] |> x -> map(i -> i.I[2], x)
# scatter!(𝐱ₙ[1,:], 𝐱ₙ[2,:], color=kₙ)
# scatter!(𝛍ₖ[1,:], 𝛍ₖ[2,:], m=(:xcross,10), color=1:K)
# savefig(plt, joinpath(@__DIR__, "cover-image.png"))

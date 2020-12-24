#=
demo:
- Julia version: 1.5.3
- Author: kenychen
- Date: 2020-12-23
=#
using Pkg
Pkg.add("Flux")
Pkg.add("MLDatasets")
Pkg.add("Lathe")
#download MNIST
using MLDatasets
FashionMNIST.download(i_accept_the_terms_of_use=true)
train_x, train_y = FashionMNIST.traindata();
test_x,  test_y  = FashionMNIST.testdata();
#import Flux
using Flux, Statistics
using Flux: onehotbatch, onecold, crossentropy, throttle, params
using Lathe.stats: mean
using Base.Iterators: partition
using Random
#model
model() = Chain(
  Conv((5, 5), 1 => 64, elu, pad=(2, 2), stride=(1, 1)),
  BatchNorm(64),
  MaxPool((3, 3), pad=(2, 2), stride=(2, 2)),
  Dropout(0.25),
  Conv((5, 5), 64 => 128, elu, pad=(2, 2), stride=(1, 1)),
  BatchNorm(128),
  MaxPool((2, 2), stride=(2, 2)),
  Dropout(0.25),
  Conv((5, 5), 128 => 256, elu, pad=(2, 2), stride=(1, 1)),
  BatchNorm(256),
  MaxPool((2, 2), stride=(2, 2)),
  Dropout(0.25),
  x -> reshape(x, :, size(x, 4)),
  Dense(2304, 256, elu),
  Dropout(0.5),
  Dense(256, 10),
  softmax) |> gpu
N = size(train_x)[end]
ixs = collect(1:N)
shuffle!(ixs)
n = Int(floor(.9 * N))
function make_batches(data; bs=100)
    n = size(data[1])[end]
    sz = (28, 28, 1, bs)
    iter = [(reshape(Float32.(data[1][:, :, i]), sz), onehotbatch(data[2][i], 0:9)) for i in partition(1:n, bs)] |> gpu
end

#train = make_batches(train)

train = make_batches(train_x)
val = make_batches(val)
test = make_batches(test);
m = model()

function met(data)
    global batch_idx
    acc = 0
    for batch in data
        x, y = batch
        pred = m(x) .> 0.5
        tp = Float32(sum((pred .+ y) .== Int16(2)))
        fp = Float32(sum((pred .- y) .== Int16(1)))
        fn = Float32(sum((pred .- y) .== Int16(-1)))
        tn = Float32(sum((pred .+ y) .== Int16(0)))
        acc += (tp + tn) / (tp + tn + fp + fn)
    end
    acc /= length(data)
    push!(eval_acc, acc)
    if batch_idx % 100 == 0
        @show(batch_idx)
    end

    batch_idx += 1
end

loss(x, y) = crossentropy(m(x), y)
evalcb = () -> met(val)

Flux.train!(loss, params(m), train, opt, cb = evalcb)

met(test)
println("accuracy:", eval_acc[1])


#train = make_batches(train_x)
function day20_parseinput(filename=joinpath(@__DIR__, "input.txt"))
    map(Base.Fix1(parse, Int), readlines(filename))
end

function Base.findfirst(f::Function, l::MutableLinkedList{T}) where {T}
    for (i, h) in enumerate(l)
        f(h) && return i
    end
    return nothing
end

function Base.insert!(l::MutableLinkedList{T}, idx::Int, data) where {T}
    @boundscheck 0 < idx <= l.len + 1 || throw(BoundsError(l, idx))
    prev = l.node
    for i in 1:idx-1
        prev = prev.next
    end
    next = prev.next
    node = DataStructures.ListNode{T}(data)
    node.prev = prev
    node.next = next
    prev.next = node
    next.prev = node
    l.len += 1
    return l
end

function Base.popat!(l::MutableLinkedList, idx::Int)
    @boundscheck 0 < idx <= l.len || throw(BoundsError(l, idx))
    node = l.node
    for i = 1:idx
        node = node.next
    end
    prev = node.prev
    next = node.next
    prev.next = next
    next.prev = prev
    l.len -= 1
    return node.data
end

function day20_decrypt(input, num_rounds, N=length(input))
    l = MutableLinkedList{eltype(enumerate(input))}(enumerate(input)...)

    for _ = 1:num_rounds
        for i = 1:N
            src = findfirst(x -> x[1] == i, l)
            node = popat!(l, src)
            dest = mod1(src + node[2], N - 1)
            insert!(l, dest, node)
        end
    end

    idx = findfirst(x -> x[2] == 0, l)
    sum(x -> l[mod1(idx + x, N)][2], (1000, 2000, 3000))
end

day20_part1(input) = day20_decrypt(input, 1)
day20_part2(input) = day20_decrypt(input * 811589153, 10)

@testset "day20" begin
    input = day20_parseinput()
    @test day20_part1(input) == 11037
    @test day20_part2(input) == 3033720253914
end

export day20_parseinput, day20_part1, day20_part2

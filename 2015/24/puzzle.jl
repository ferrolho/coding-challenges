function day24()
    input = joinpath(@__DIR__, "input.txt")
    packages = readlines(input) |>
               x -> parse.(Int, x) |>
               x -> sort(x, rev=true)

    entanglement(packages) = prod(packages)

    function part₁(packages)
        best₁ = nothing
        best_qe₁ = nothing

        for g₁ = combinations(packages)
            qe₁ = entanglement(g₁)
            if !isnothing(best₁)
                length(g₁) > length(best₁) && break
                qe₁ >= best_qe₁ && continue
            end

            g₂₃ = setdiff(packages, g₁)
            wg₁, wg₂₃ = sum(g₁), sum(g₂₃)
            wg₁ != wg₂₃ / 2 && continue

            for (g₂, g₃) in partitions(g₂₃, 2)
                wg₂, wg₃ = sum(g₂), sum(g₃)
                wg₂ != wg₃ && continue

                if isnothing(best₁) ||
                   (length(g₁) < length(best₁)) ||
                   (length(g₁) == length(best₁) && qe₁ < best_qe₁)
                    best₁ = g₁
                    best_qe₁ = qe₁
                end
            end
        end

        best_qe₁
    end

    function part₂(packages)
        best₁ = nothing
        best_qe₁ = nothing

        best₂ = nothing
        best_qe₂ = nothing

        for g₁ = combinations(packages)
            qe₁ = entanglement(g₁)
            if !isnothing(best₁)
                length(g₁) > length(best₁) && break
                qe₁ >= best_qe₁ && continue
            end

            g₂₃₄ = setdiff(packages, g₁)
            wg₁, wg₂₃₄ = sum(g₁), sum(g₂₃₄)
            wg₁ != wg₂₃₄ / 3 && continue

            for g₂ = combinations(g₂₃₄)
                wg₂ = sum(g₂)
                wg₁ != wg₂ && continue

                qe₂ = entanglement(g₂)
                if !isnothing(best₂)
                    length(g₂) > length(best₂[1]) && break
                    qe₂ >= best_qe₂ && continue
                end

                g₃₄ = setdiff(g₂₃₄, g₂)
                wg₃₄ = sum(g₃₄)
                wg₂ != wg₃₄ / 2 && continue

                for (g₃, g₄) in partitions(g₃₄, 2)
                    wg₃, wg₄ = sum(g₃), sum(g₄)
                    wg₃ != wg₄ && continue

                    if isnothing(best₁) ||
                       (length(g₁) < length(best₁)) ||
                       (length(g₁) == length(best₁) && qe₁ < best_qe₁)
                        best₁ = g₁
                        best_qe₁ = qe₁
                    end

                    if isnothing(best₂) ||
                       (length(g₂) < length(best₂)) ||
                       (length(g₂) == length(best₂) && qe₂ < best_qe₂)
                        best₂ = g₂
                        best_qe₂ = qe₂
                    end
                end
            end
        end

        best_qe₁
    end

    result₁ = part₁(packages)
    result₂ = part₂(packages)

    # @assert result₁ == 11846773891
    # @assert result₂ == 80393059

    result₁, result₂
end

export day24

function day4()
    input = joinpath(@__DIR__, "input.txt")

    passports = [Dict()]

    for line in eachline(input)
        if isempty(line)
            push!(passports, Dict())
        else
            entries = line |> split .|> x -> split(x, ":")

            foreach(entries) do (k, v)
                last(passports)[k] = v
            end
        end
    end

    function isvalid₁(p)
        required_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        all(map(x -> haskey(p, x), required_keys))
    end

    function isvalid₂(p)
        required_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
        !all(map(x -> haskey(p, x), required_keys)) && return false

        !(1920 ≤ parse(Int, p["byr"]) ≤ 2002) && return false
        !(2010 ≤ parse(Int, p["iyr"]) ≤ 2020) && return false
        !(2020 ≤ parse(Int, p["eyr"]) ≤ 2030) && return false

        hgt = p["hgt"]
        height, unit = parse(Int, hgt[1:end - 2]), last(hgt, 2)
        unit == "cm" && !(150 ≤ height ≤ 193) && return false
        unit == "in" && !( 59 ≤ height ≤  76) && return false
        unit ∉ ["cm", "in"] && return false

        !occursin(r"#[0-9a-f]{6}$", p["hcl"]) && return false

        valid_ecl = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
        p["ecl"] ∉ valid_ecl && return false

        !occursin(r"^[0-9]{9}$", p["pid"]) && return false

        return true
    end

    result₁ = count(isvalid₁, passports)
    result₂ = count(isvalid₂, passports)

    # result₁ = @btime count($isvalid₁, $passports)
    # result₂ = @btime count($isvalid₂, $passports)

    result₁, result₂
end

export day4

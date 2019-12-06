function day4()
    input = vec(readdlm("./04/input.txt", '-', Int))
    range = input[1]:input[2]

    not_decreasing(s) = join(sort(collect(s))) == s

    function rule_1(s)
        # Scan string
        for i = 1:length(s)-1
            s[i] == s[i+1] && return true
        end
        return false
    end

    function rule_2(s)
        # Corner cases
        s[1] == s[2] != s[3] && return true
        s[end-2] != s[end-1] == s[end] && return true
        # Check rest of the string
        for i = 2:length(s)-2
            s[i-1] != s[i] == s[i+1] != s[i+2] && return true
        end
        return false
    end

    meets_criteria_1(s) = not_decreasing(s) && rule_1(s)
    meets_criteria_2(s) = not_decreasing(s) && rule_2(s)

    result_1 = count(x -> meets_criteria_1(string(x)), range)
    result_2 = count(x -> meets_criteria_2(string(x)), range)

    result_1, result_2
end

export day4

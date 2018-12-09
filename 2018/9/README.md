# Day 9: Marble Mania

I tried *three* different approaches to solve today's puzzle. Here is an overview of all of them:

> **Disclaimer:** As of yet, only one of them managed to produce satisfactory results.

**Attempt no. 1**  
The first approach ([slow.py](https://github.com/ferrolho/advent-of-code/blob/master/2018/9/slow.py)) used your average NumPy array and became infeasible for the input of part two.

**Attempt no. 2**  
My second approach ([analytic.py](https://github.com/ferrolho/advent-of-code/blob/master/2018/9/analytic.py)) was trying to find an analytic solution, but I failed to get the pattern of the score for the marbles that get to be removed from the circle of marbles... Apparently, I was not the only one who spent hours on this: [r/adventofcode](https://www.reddit.com/r/adventofcode/comments/a4o1y9/could_day_9_have_a_closed_form_solution/).

**Attempt no. 3**  
My third and final approach ([puzzle.py](https://github.com/ferrolho/advent-of-code/blob/master/2018/9/puzzle.py)) was to implement my own circular doubly linked list to get Θ(1) insertion/deletion complexity.

import re  # For safer recurrence parsing
from sympy import symbols, sympify, Sum, latex
from sympy.abc import n, k, a, d, r


# --- Arithmetic Sequence Logic ---
def generate_arithmetic_solution(a_val, d_val, n_val):
    an_sym = a + (n - 1) * d
    sn_sym = n / 2 * (2 * a + (n - 1) * d)

    steps = [
        f"Given: First term (a) = {a_val}, Common difference (d) = {d_val}, Term number (n) = {n_val}",
        "\n--- Nth Term Calculation ---",
        "The formula for the nth term of an arithmetic sequence is: $a_n = a + (n-1)d$",
        f"Substitute the given values: $a_{{{n_val}}} = {a_val} + ({n_val}-1){d_val}$",
        f"$a_{{{n_val}}} = {a_val} + ({n_val - 1}){d_val}$",
        f"$a_{{{n_val}}} = {a_val} + {(n_val - 1) * d_val}$"]
    nth_term_value = a_val + (n_val - 1) * d_val
    steps.append(f"$a_{{{n_val}}} = {nth_term_value}$")

    steps.append("\n--- Sum of N Terms Calculation ---")
    steps.append(
        "The formula for the sum of the first n terms of an arithmetic sequence is: $S_n = \\frac{n}{2}(2a + (n-1)d)$")
    steps.append(
        f"Substitute the given values: $S_{{{n_val}}} = \\frac{{{n_val}}}{{2}}(2({a_val}) + ({n_val}-1){d_val})$")
    steps.append(f"$S_{{{n_val}}} = \\frac{{{n_val}}}{{2}}({2 * a_val} + ({n_val - 1}){d_val})$")
    steps.append(f"$S_{{{n_val}}} = \\frac{{{n_val}}}{{2}}({2 * a_val} + {(n_val - 1) * d_val})$")
    steps.append(f"$S_{{{n_val}}} = \\frac{{{n_val}}}{{2}}({2 * a_val + (n_val - 1) * d_val})$")
    sum_value = (n_val / 2) * (2 * a_val + (n_val - 1) * d_val)
    steps.append(f"$S_{{{n_val}}} = {sum_value}$")

    graph_points = []
    for i in range(1, n_val + 1):
        graph_points.append(float(a_val + (i - 1) * d_val))

    return {
        "type": "arithmetic",
        "nth_term_formula_latex": latex(an_sym),
        "nth_term_value": str(nth_term_value),
        "sum_formula_latex": latex(sn_sym),
        "sum_value": str(sum_value),
        "step_by_step_solution": "\n".join(steps),
        "graph_points": graph_points,
    }


# --- Geometric Sequence Logic ---
def generate_geometric_solution(a_val, r_val, n_val, is_infinite):
    an_sym = a * r ** (n - 1)
    sn_sym_finite = a * (1 - r ** n) / (1 - r)
    sn_sym_infinite = a / (1 - r) if abs(r_val) < 1 else 'diverges'

    steps = []
    steps.append(f"Given: First term (a) = {a_val}, Common ratio (r) = {r_val}")
    if not is_infinite:
        steps.append(f"Term number (n) = {n_val}")

    steps.append("\n--- Nth Term Calculation ---")
    steps.append("The formula for the nth term of a geometric sequence is: $a_n = ar^{n-1}$")
    if not is_infinite:
        steps.append(
            f"Substitute the given values: $a_{{{n_val}}} = {a_val} \\cdot {r_val}^{{{n_val}-1}}$")
        nth_term_value = a_val * (r_val ** (n_val - 1))
        steps.append(f"$a_{{{n_val}}} = {nth_term_value}$")
    else:
        steps.append(
            "Nth term calculation is not directly applicable for an infinite series in the same way as finite.")
        nth_term_value = "N/A (Infinite Series)"

    steps.append("\n--- Sum Calculation ---")
    if is_infinite:
        if abs(r_val) < 1:
            steps.append(
                "For an infinite geometric series where $|r| < 1$, the sum is: $S_\\infty = \\frac{a}{1-r}$")
            steps.append(
                f"Substitute the given values: $S_\\infty = \\frac{{{a_val}}}{{1-{r_val}}}$")
            sum_value = a_val / (1 - r_val)
            steps.append(f"$S_\\infty = {sum_value}$")
        else:
            sum_value = "Diverges"
            steps.append("The infinite geometric series diverges because $|r| \\ge 1$.")
    else:
        steps.append(
            "The formula for the sum of the first n terms of a geometric sequence is: $S_n = \\frac{a(1-r^n)}{1-r}$")
        steps.append(
            f"Substitute the given values: $S_{{{n_val}}} = \\frac{{{a_val}(1-{r_val}^{{{n_val}}})}}{{1-{r_val}}}$")
        if r_val == 1:
            sum_value = a_val * n_val
            steps.append(f"If r=1, $S_n = n \\cdot a = {n_val} \\cdot {a_val} = {sum_value}$")
        else:
            sum_value = a_val * (1 - r_val ** n_val) / (1 - r_val)
            steps.append(f"$S_{{{n_val}}} = {sum_value}$")

    graph_points = []
    limit = n_val if not is_infinite else 10
    for i in range(1, limit + 1):
        graph_points.append(float(a_val * (r_val ** (i - 1))))

    return {
        "type": "geometric",
        "nth_term_formula_latex": latex(an_sym),
        "nth_term_value": str(nth_term_value),
        "sum_formula_latex": latex(sn_sym_infinite if is_infinite else sn_sym_finite),
        "sum_value": str(sum_value),
        "step_by_step_solution": "\n".join(steps),
        "graph_points": graph_points,
    }


# --- Sigma Notation Logic ---
def sigma_calculation_logic(expression_str, variable_str, lower_bound, upperBound):
    try:
        var = symbols(variable_str)
        # Using sympify for parsing, but still warn about user input security if not validated
        expr = sympify(expression_str, locals={variable_str: var})

        total_sum = Sum(expr, (var, lower_bound, upperBound)).doit()

        steps = []
        steps.append(
            f"Given sum: $\\sum_{{{var}={lower_bound}}}^{{{upper_bound}}} ({latex(expr)})$")
        steps.append("Expand the sum by substituting values from lower bound to upper bound:")
        sum_terms = []
        graph_points = []
        for i in range(lower_bound, upperBound + 1):
            term = expr.subs(var, i)
            sum_terms.append(str(term))
            graph_points.append(float(term))
            steps.append(f"For ${var}={i}$: ${latex(expr.subs(var, i))}$")

        steps.append("\nAdd the terms together:")
        steps.append(f"{' + '.join(sum_terms)} = {total_sum}")

        return {
            "type": "sigma",
            "sum_value": str(total_sum),
            "step_by_step_solution": "\n".join(steps),
            "graph_points": graph_points,
        }
    except Exception as e:
        return {"error": f"Error parsing or calculating sigma notation: {e}"}


# --- Recurrence Relation Logic (Simplified and Safer) ---
def recurrence_calculation_logic(recurrence_relation, initial_conditions_raw, n_val):
    # IMPORTANT SECURITY NOTE:
    # Parsing arbitrary recurrence relations from strings is complex and can be a security risk
    # if not done carefully. This implementation is simplified for demonstration and
    # handles common linear relations. For a production app, a robust, secure parser
    # or a more controlled input mechanism is highly recommended.
    # Avoid using `eval()` directly on untrusted user input.

    try:
        initial_conditions = {}
        for k_str, v_val in initial_conditions_raw.items():
            # Example: 'a(0)' -> 0, 'a(1)' -> 1
            idx_match = re.search(r'a\((\d+)\)', k_str)
            if idx_match:
                idx = int(idx_match.group(1))
                initial_conditions[idx] = float(v_val)
            else:
                raise ValueError(f"Invalid initial condition key format: {k_str}")

        sorted_initial_conditions = sorted(initial_conditions.items())

        terms = {}
        steps = []
        graph_points = []

        for idx, val in sorted_initial_conditions:
            terms[idx] = val
            steps.append(f"Initial condition: $a({idx}) = {val}$")
            graph_points.append(float(val))

        # Basic parsing of recurrence relation for common patterns
        # This is NOT a full symbolic parser. It handles specific patterns.
        # Example patterns: "a(n) = a(n-1) + a(n-2)", "a(n) = 2*a(n-1) + 3"

        # Replace 'a(n-k)' with a placeholder that can be substituted
        relation_processed = recurrence_relation.replace("a(n)", "").replace("=", "").strip()

        # Identify required past terms (e.g., n-1, n-2)
        required_offsets = set()
        matches = re.findall(r'a\(n-(\d+)\)', relation_processed)
        for m in matches:
            required_offsets.add(int(m))

        # Determine the starting index for calculation based on initial conditions
        start_index = max(terms.keys()) + 1 if terms else 0

        for i in range(start_index, n_val + 1):
            term_expression = relation_processed
            can_calculate = True

            # Substitute previous terms into the expression
            for offset in required_offsets:
                prev_index = i - offset
                if prev_index in terms:
                    term_expression = term_expression.replace(f"a(n-{offset})",
                                                              str(terms[prev_index]))
                else:
                    can_calculate = False
                    break  # Cannot calculate if a required previous term is missing

            if not can_calculate:
                steps.append(
                    f"Cannot calculate $a({i})$: Missing initial conditions for required previous terms.")
                # If we can't calculate a term, we can't proceed to n_val.
                # This means the provided initial conditions are insufficient for the requested n.
                final_n_term_value = "Insufficient initial conditions"
                break

            try:
                # Evaluate the expression using sympy's sympify for safer arithmetic evaluation
                # Still, be cautious with user input in `term_expression`.
                # For a production app, consider a more controlled expression evaluator.
                current_term_value = sympify(term_expression).evalf()
                terms[i] = float(current_term_value)
                steps.append(f"$a({i}) = {term_expression} = {current_term_value}$")
                graph_points.append(float(current_term_value))
            except Exception as eval_e:
                steps.append(f"Error evaluating $a({i})$: {eval_e}. Expression: {term_expression}")
                final_n_term_value = f"Error in relation evaluation: {eval_e}"
                break  # Stop if evaluation fails

        final_n_term_value = terms.get(n_val, "Not calculated or insufficient conditions")

        return {
            "type": "recurrence",
            "nth_term_value": str(final_n_term_value),
            "step_by_step_solution": "\n".join(steps),
            "graph_points": graph_points,
        }
    except Exception as e:
        return {"error": f"Error calculating recurrence: {e}"}


# --- Dummy main for local testing of python script (not used by FFI) ---
if __name__ == '__main__':
    # Example usage for local testing
    print("Testing Arithmetic:")
    print(generate_arithmetic_solution(2, 3, 5))

    print("\nTesting Geometric:")
    print(generate_geometric_solution(10, 0.5, 4, False))
    print(generate_geometric_solution(10, 0.5, 0, True))

    print("\nTesting Sigma:")
    print(sigma_calculation_logic("k**2", "k", 1, 3))

    print("\nTesting Recurrence (Fibonacci):")
    initial_fib = {"a(0)": 0.0, "a(1)": 1.0}
    print(recurrence_calculation_logic("a(n) = a(n-1) + a(n-2)", initial_fib, 5))

    print("\nTesting Recurrence (Linear):")
    initial_linear = {"a(0)": 1.0}
    print(recurrence_calculation_logic("a(n) = 2*a(n-1) + 3", initial_linear, 3))

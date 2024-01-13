# RangeEnclosures.jl

| **Documentation** | **Status** | **Community** |**Version-specific Citation** | **License** |
|:-----------------:|:----------:|:-------------:|:----------------------------:|:-----------:|
| [![docs-dev][dev-img]][dev-url] | [![CI][ci-img]][ci-url] [![codecov][cov-img]][cov-url] | [![zulip][chat-img]][chat-url] | [![zenodo][doi-img]][doi-url] | [![license][lic-img]][lic-url] |

[dev-img]: https://img.shields.io/badge/docs-latest-blue.svg
[dev-url]: https://juliareach.github.io/RangeEnclosures.jl/dev/
[ci-img]: https://github.com/JuliaReach/RangeEnclosures.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/JuliaReach/RangeEnclosures.jl/actions/workflows/ci.yml
[cov-img]: https://codecov.io/github/JuliaReach/RangeEnclosures.jl/coverage.svg
[cov-url]: https://app.codecov.io/github/JuliaReach/RangeEnclosures.jl
[chat-img]: https://img.shields.io/badge/zulip-join_chat-brightgreen.svg
[chat-url]: https://julialang.zulipchat.com/#narrow/stream/278609-juliareach
[doi-img]: https://zenodo.org/badge/196427971.svg
[doi-url]: https://zenodo.org/badge/latestdoi/196427971
[lic-img]: https://img.shields.io/github/license/mashape/apistatus.svg
[lic-url]: https://github.com/JuliaReach/RangeEnclosures.jl/blob/master/LICENSE

A [Julia](http://julialang.org) package to bound the range of real-valued functions.

## Installing

From the Julia REPL type

```julia
julia> using Pkg; Pkg.add("RangeEnclosures")
```

## Quickstart

An *enclosure* of the [range](https://en.wikipedia.org/wiki/Range_of_a_function)
of a function $f : D \subset \mathbb{R}^n \to \mathbb{R}$ is an interval that
contains the global minimum and maximum of $f$ over its domain $D$.
`RangeEnclosures` offers an API to easily bound the range of $f$ with different
algorithms. Here is a quick example:

```julia
julia> f(x) = -x^3/6 + 5x

julia> dom = 1 .. 4
[1, 4]

julia> enclose(f, dom, BranchAndBoundEnclosure())
[4.83333, 10.5709]
```

![Example](https://github.com/JuliaReach/RangeEnclosures.jl/blob/master/docs/src/assets//readme_example.png?raw=true)

<!--code to generate plot
using RangeEnclosures, Plots
f(x) = -x^3/6 + 5x
dom = 1 .. 4
b = enclose(f, dom, BranchAndBoundEnclosure())
plot(xlab="x", leg=:right)
plot!(x -> sup(b), 1, 4, c=:red, s=:dash, lw=2, lab="upper bound")
plot!(f, 1, 4, c=:blue, lw=2, lab="f(x)")
plot!(x -> inf(b), c=:orange, s=:dash, lw=2, lab="lower bound")
savefig("readme_example")
-->

We plan to add more examples to the
[docs](http://juliareach.github.io/RangeEnclosures.jl/latest/). In the meantime,
check the [test](https://github.com/JuliaReach/RangeEnclosures.jl/tree/master/test)
folder for further examples.

## Contributing

If you encounter bugs, want to suggest new features or have questions, feel free
to [open an issue](https://github.com/JuliaReach/RangeEnclosures.jl/issues/new).
You can also chat with the package developers on
[Gitter](https://gitter.im/JuliaReach/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
or in the `#reachability-analysis` stream on
[Zulip](https://julialang.zulipchat.com/). Pull requests implementing new
features or fixing bugs are also welcome. Make sure to check out the
[contribution guidelines](https://juliareach.github.io/RangeEnclosures.jl/dev/about/#Contributing-1).

## Authors

- [Luca Ferranti](https://github.com/lucaferranti)
- [Marcelo Forets](https://github.com/mforets)
- [Christian Schilling](https://github.com/schillic)

## Acknowledgments

Huge thanks to all the [contributors](https://github.com/JuliaReach/RangeEnclosures.jl/graphs/contributors). 
In addition, we are grateful to [Luis Benet](https://github.com/lbenet), [Benoît Legat](https://github.com/blegat/) and [David P. Sanders](https://github.com/dpsanders/) for enlightening discussions
during the preparation of this package.

During Summer 2022, this project was financially supported by Google through the
Google Summer of Code program.
During Summer 2019, this project was financially supported by Julia through the
Julia Season of Contributions program.

If you use `RangeEnclosures.jl`, consider acknowledging or citing the Julia package
that implements the specific solver that you are using.

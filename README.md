# RangeEnclosures.jl

[![Build Status](https://github.com/JuliaReach/RangeEnclosures.jl/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/JuliaReach/RangeEnclosures.jl/actions/workflows/ci.yml?query=branch%3Amaster)
<!--[![Docs latest](https://img.shields.io/badge/docs-stable-blue.svg)](http://juliareach.github.io/RangeEnclosures.jl/latest/)-->
[![Docs dev](https://img.shields.io/badge/docs-dev-blue.svg)](http://juliareach.github.io/RangeEnclosures.jl/dev/)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)](LICENSE)
[![Code coverage](http://codecov.io/github/JuliaReach/RangeEnclosures.jl/coverage.svg?branch=master)](https://codecov.io/github/JuliaReach/RangeEnclosures.jl?branch=master)
[![Join the chat at https://gitter.im/JuliaReach/Lobby](https://badges.gitter.im/JuliaReach/Lobby.svg)](https://gitter.im/JuliaReach/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A [Julia](http://julialang.org) package to bound the range of real-valued functions.

## Installing

From the Julia REPL type

```julia
julia> using Pkg; Pkg.add(url="https://github.com/JuliaReach/RangeEnclosures.jl.git")
```

## Quickstart

An *enclosure* of the [range](https://en.wikipedia.org/wiki/Range_(mathematics)) of a function $f : D \subset \mathbb{R}^n \to \mathbb{R}$ is an interval
that contains the global minimum and maximum of $f$ over its domain $D$. `RangeEnclosures` offers an API to easily bound the range of
$f$ with different algorithms. Here is a quick example:

```julia
julia> f(x) = -x^3/6 + 5x

julia> dom = 1 .. 4
[1, 4]

julia> enclose(f, dom, BranchAndBoundEnclosure())
[4.83333, 10.5709]
```

We plan to add more examples to the [docs](http://juliareach.github.io/RangeEnclosures.jl/latest/); in the meantime, you can check the [test](https://github.com/JuliaReach/RangeEnclosures.jl/tree/master/test) folder for further examples. 

## Contributing

If you encounter bugs, want to suggest new features or have questions, feel free to [open an issue](https://github.com/JuliaReach/RangeEnclosures.jl/issues/new). You can also chat with the package developers on [gitter](https://gitter.im/JuliaReach/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) or in the `#reachability-analysis` stream on [julia zulip](https://julialang.zulipchat.com/). Pull requests implementing new features or fixing bugs are also welcome. Make sure to check out the [contribution guidelines](https://juliareach.github.io/RangeEnclosures.jl/dev/about/#Contributing-1).

## Authors

- [Luca Ferranti](https://github.com/lucaferranti)
- [Marcelo Forets](https://github.com/mforets)
- [Christian Schilling](https://github.com/schillic)

## Acknowledgements

Huge thanks to all the [contributors](https://github.com/JuliaReach/RangeEnclosures.jl/graphs/contributors).

During Summer 2022, this project was financially supported by Google through the Google Summer of Code programme.
During Summer 2019, this project was financially supported by Julia through the Julia Season of Contributions programme.

In addition, we are grateful to the following persons for enlightening discussions
during the preparation of this package:

- [Luis Benet](https://github.com/lbenet)
- [Benoît Legat](https://github.com/blegat/)
- [David P. Sanders](https://github.com/dpsanders/)

<!--
## Acknowledgements

If you use `RangeEnclosures.jl`, consider acknowledging or citing the Julia package
that implements the specific solver that you are using.

This package was completed during Aadesh Deshmuhk's [Julia Seasons of Contributions
(JSOC)](https://julialang.org/soc/ideas-page) 2019. 
In addition, we are grateful to the following persons for enlightening discussions
during the preparation of this package:

- [Luis Benet](https://github.com/lbenet)
- [Benoît Legat](https://github.com/blegat/)
- [David P. Sanders](https://github.com/dpsanders/)
-->

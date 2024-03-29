# About

This page contains some general information about this project, and
recommendations about contributing.

```@contents
Pages = ["about.md"]
```

## Contributing

If you like this package, consider contributing!
You can send bug reports (or fix them and send your code), add examples to the
documentation, or propose new features.

Below some conventions that we follow when contributing to this package are
detailed.
For specific guidelines on documentation, see the
[Documentations Guidelines wiki](https://github.com/JuliaReach/LazySets.jl/wiki/Documentation-Guidelines).

### Branches and pull requests (PR)

We use a standard pull request policy:
You work in a private branch and eventually add a pull request, which is then
reviewed by other programmers and merged into the `master` branch.

Each pull request should be pushed in a new branch with the name of the author
followed by a descriptive name, e.g., `mforets/my_feature`.
If the branch is associated to a previous discussion in one issue, we use the
name of the issue for easier lookup, e.g., `mforets/7`.

### Unit testing and continuous integration (CI)

This project is synchronized with GitHub Actions such that each PR gets tested
before merging (and the build is automatically triggered after each new commit).
For the maintainability of this project, it is important to make all unit tests
pass.

To run the unit tests locally, you can do:

```julia
julia> using Pkg

julia> Pkg.test("RangeEnclosures")
```

We also advise adding new unit tests when adding new features to ensure
long-term support of your contributions.

### Contributing to the documentation

New functions and types should be documented according to our
[guidelines](https://github.com/JuliaReach/LazySets.jl/wiki/Documentation-Guidelines)
directly in the source code.

You can view the source code documentation from inside the REPL by typing `?`
followed by the name of the type or function.
For example, the following command will print the documentation of the `enclose`
function:

```
julia> ?enclose
```

This documentation you are currently reading is written in Markdown, and it
relies on [Documenter.jl](https://juliadocs.github.io/Documenter.jl/stable/) to
produce the HTML layout.
The sources for creating this documentation are found in `docs/src`.
You can easily include the documentation that you wrote for your functions or
types there (see the
[Documenter.jl guide](https://juliadocs.github.io/Documenter.jl/stable/man/guide/)
or our sources for examples).

To generate the documentation locally, run `make.jl`, e.g., by executing the
following command in the terminal:

```bash
$ julia --color=yes docs/make.jl
```

## Credits

### Core developers

The `RangeEnclosures.jl` library is maintained by (in alphabetic order):

- [Luca Ferranti](https://github.com/lucaferranti), University of Vasaa
- [Marcelo Forets](http://github.com/mforets), Universidad de la República
- [Christian Schilling](https://www.christianschilling.net/), Aalborg University

### Contributors

Huge thanks to all the
[contributors](https://github.com/JuliaReach/RangeEnclosures.jl/graphs/contributors).

### Acknowledgments

We are grateful to the following persons for enlightening discussions during the
preparation of this package:

- [Luis Benet](https://github.com/lbenet)
- [Benoît Legat](https://github.com/blegat/)
- [David P. Sanders](https://github.com/dpsanders/)

During Summer 2022, this project was financially supported by Google through the
Google Summer of Code program.
During Summer 2019, this project was financially supported by Julia through the
Julia Season of Contributions program.

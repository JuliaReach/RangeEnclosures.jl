# Methods

This section describes systems methods implemented in `RangeEnclosures.jl`.

```@contents
Pages = ["methods.md"]
Depth = 3
```

```@meta
CurrentModule = RangeEnclosures
DocTestSetup = quote
    using RangeEnclosures
end
```

## The `enclose` function

```@docs
enclose
```

## Utility functions

```@docs
relative_precision
```

## Enclosure methods

```@docs
enclose_IntervalArithmetic
enclose_IntervalOptimisation
enclose_TaylorModels
enclose_SumOfSquares
```

## Specifics to interval optimization

```@docs
range_and_optimisers
```

## Specifics to sum-of-squares optimization

```@docs
new_sos
```

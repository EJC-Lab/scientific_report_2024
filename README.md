
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Scientific Report 2024 paper

<!-- badges: start -->
<!-- badges: end -->

The goal of this package is to apply the People-like-me (PLM) methods with different setups. 
The SR2024 paper is mainly focused on the basic setups for PLM with sinlge anchor time matching methods.
The package it contains further investigations on multiple time matching and flexible matching donor selection methods.

## Installation

You can install the development version of plmphd from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Goodgolden/plmphd")
```

## Example

This is a basic example which using the simulated dataset to perform single target PLM method, as well as multiple target PLM (currently named as `people-like-us()`).

``` r
library(plmphd)
```


You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.

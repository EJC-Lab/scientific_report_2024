
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

This is a basic example which shows you how to solve a common problem:

``` r
library(plmphd)
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.

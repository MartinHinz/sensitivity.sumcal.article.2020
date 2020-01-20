
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Research compendium for ‘Sensitivity of Radiocarbon Sum Calibration’

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/MartinHinz/sensitivity.sumcal.article.2020/master?urlpath=rstudio)
[![Travis-CI Build
Status](https://travis-ci.org/MartinHinz/sensitivity.sumcal.article.2020.svg?branch=master)](https://travis-ci.org/MartinHinz/sensitivity.sumcal.article.2020)
[![codecov](https://codecov.io/github/MartinHinz/sensitivity.sumcal.article.2020/branch/master/graphs/badge.svg)](https://codecov.io/github/MartinHinz/sensitivity.sumcal.article.2020)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3613674.svg)](https://doi.org/10.5281/zenodo.3613674)
[![PrePrint](https://img.shields.io/badge/SocArXiv-bgvk6-green)](https://osf.io/preprints/socarxiv/bgvk6/)

This repository contains the data and code for the paper:

> Hinz, (2020). *Sensitivity of Radiocarbon Sum Calibration*. Zenodo
> <https://doi.org/10.5281/zenodo.3613674>

The pre-print is online here:

> Hinz, (2020). *Sensitivity of Radiocarbon Sum Calibration*. SocArXiv,
> Accessed 20 Jan 2020. Online at
> <https://osf.io/preprints/socarxiv/bgvk6>

### Author

[![ORCiD](https://img.shields.io/badge/ORCiD-0000--0002--9904--6548-green.svg)](http://orcid.org/0000-0002-9904-6548)
Martin Hinz (<martin.hinz@iaw.unibe.ch>)

### Abstract

Sum calibration has become a standard tool for demographic studies, even
though the methodology itself is far from uncontroversial. In addition
to fundamental methodological criticism, questions are frequently raised
about the sample size and data density required to detect large-scale
changes in past populations. This article uses a simulation approach to
determine the detection probabilities for events of varying intensity
and with varying data density. At the same time, the effectiveness of
Monte Carlo-based confidence envelopes as a countermeasure against
false-positive results is tested. The results show that the detection of
such events is not unlikely and that the Monte Carlo method is well
suited to separate signal and noise. However, the nature of the events
already observed in this way demands further assessment.

### Highlights

  - Simulations used to evaluate the possibility of reconstructing
    prehistoric demography from 14C data
  - Random sampling of 14C data using given probability distributions
  - Test the sensitivity of a summed 14C proxy curve to population
    fluctuations
  - Demographic signals can be separated from noise in summed 14C
    distributions using appropriate techniques

### Keywords

Prehistoric demography; Summed radiocarbon date distributions;
Simulation; Calibration; Population proxies

### How to cite

Please cite this compendium as:

> Hinz, (2020). *Compendium of R code and data for Sensitivity of
> Radiocarbon Sum Calibration*. Accessed 20 Jan 2020. Online at
> <https://doi.org/10.5281/zenodo.3613674>

### How to download or install

You can download the compendium as a zip from from this URL:
<https://github.com/MartinHinz/sensitivity.sumcal.article.2020/archive/master.zip>

Or you can install this compendium as an R package,
sensitivity.sumcal.article.2020, from GitHub with:

``` r
# install.packages("devtools")
remotes::install_github("MartinHinz/sensitivity.sumcal.article.2020")
```

### Overview of contents:

This repository contains text, code and data for the paper. The
`analysis` directory contains `paper` and `data` to reproduce the
preparations, calculations and figure renderings. The `paper` directory
contains the text for the paper in *.Rmd* format, and rendered versions
as pdf, html and docx. It also contains a directory `result_data` which
holds the results from the submitted version of the paper.

### How to reproduce:

As the data and code in this repository are complete and self-contained,
it can be reproduced with any R environment (\> version 3.5.0). The
necessary package dependencies are documented in the `DESCRIPTION` file
and can be installed manually or automatically with
`devtools::install()`.

The simulation can then be run using the `run_simulation()` command. The
total run time was 94480 seconds or 26 hours and 15 minutes (using
parallel computing on 6 cores of an Intel(R) Xeon(R) CPU E3-1240 v5 at
3.50GHz with 16 GB RAM).

### Licenses

**Text and figures :**
[CC-BY-4.0](http://creativecommons.org/licenses/by/4.0/)

**Code :** See the [DESCRIPTION](DESCRIPTION) file

**Data :** [CC-0](http://creativecommons.org/publicdomain/zero/1.0/)
attribution requested in reuse

### Contributions

We welcome contributions from everyone. Before you get started, please
see our [contributor guidelines](CONTRIBUTING.md). Please note that this
project is released with a [Contributor Code of Conduct](CONDUCT.md). By
participating in this project you agree to abide by its terms.

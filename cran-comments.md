## Version 1.0.3

* Bubacarr Bah is now the maintainer of the package.

## Version 1.0.2

* This is a path release intended to fix issues that arise on CRAN.
  * Many connections were established in examples showing how to import data
  from relational database management systems.
  * This issue was fixed by setting `eval=FALSE` for some of the corresponding
  code chunks.
  
## Resubmission

This is a resubmission. In this version I have:
  * Added a `donotrun` instruction in the examples of the `read_dhis2()` and
  `read_sormas()` functions. This helps in reducing the execution time of
  `devtools::run_examples()`.

## Resubmission

This is a resubmission. In this version I have:

  * Fixed test file size issues.
  * Corrected relative paths flagged by CRAN checks.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Resubmission

This is a resubmission. In this version I have:

* Updated the examples for reading data from DHIS2 in the vignettes to ensure full compliance with CRAN policies (e.g., no external API calls during checks).
* Addressed all issues flagged in the previous CRAN checks.
* Improved the readability and structure of the README and related documentation.
* Verified that all examples and vignettes run without errors, warnings, or notes under `R CMD check --as-cran`.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.


## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

##Resubmission

This is a resubmission. In this version I have:
  * Added a `donotrun` instruction in the examples of the `read_dhis2()` and
  `read_sormas()` functions. This helps in reducing the execution time of
  `devtools::run_examples()`.


## Version 1.0.2

* This is a path release intended to fix issues that arise on CRAN.
  * Many connections were established in examples showing how to import data
  from relational database management systems.
  * This issue was fixed by setting `eval=FALSE` for some of the corresponding
  code chunks.

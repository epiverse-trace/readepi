# readepi 1.0.3

* Bubacarr Bah is now the maintainer of the packages (#91, @Karim-Mane).

* Added package citation instructions in README file (#92, @Karim-Mane).

# readepi 1.0.2

## Enhancements

* Update document output syntax for all vignettes (#87, @Karim-Mane).

* Make sure to not evaluate on CRAN code chunk between line 86 and 123
(#87, @Karim-Mane).

* Split previous coded chunk with examples for how to import data from RDBMS,
and set `eval=FALSE` to avoid CRAN and CI platform fails (#88, @Karim-Mane). 

# readepi 1.0.0

## Enhancements

* Modified package design for harmonised data import mechanism from RDBMS,
DHIS2, SORMAS (#80, @Karim-Mane).
  
* `login()`, `read_dhis2()`, `read_sormas()` functions and their helpers for
connection to the system and data extraction from DHIS2 and SORMAS
(#80, @Karim-Mane).
  
* Added new vignettes (`query_parameters.Rmd` and `install_drivers.Rmd`) that
describe, respectively, how to use the query parameters and how to install the
Microsoft drivers that are  necessary to import data from MS SQL servers on
Linux and OSX systems (#80, @Karim-Mane).

* Added Emmanuel Kabuga as an author for his valuable contribution to this
release (#80, @Karim-Mane).
    
# readepi 0.0.1
    
* Added a `NEWS.md` file to track changes to the package.
  

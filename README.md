# Tutorial files for RMarkdown

The following files barely scratch the surface of RMarkdown and its endless possibilities.

To run the files, make sure that the working R directory is
`path/to/ssda_rmarkdown/`

You can check this with the command `getwd()`.

The following folders are present:

+ **csl**: Citation Style Language files.
   + These files determine the citation and reference style used by BiBTeX (and pandoc-citeproc) when running RMarkdown.
   + Thousand of style files are found in the [Zotero repository](https://www.zotero.org/styles/)
+ **css**: Cascading Style Sheets files
   + Determine the format for produced HTML files
   + The basics of CSS can be read in the [w3schools](https://www.w3schools.com/Css/).
+ **data**: Diverse data from US doctoral universities.
   + The data was obtained from [Integrated Postsecondary Education Data System (IPEDS)](https://nces.ed.gov/ipeds/use-the-data).
+ **figs**: PNG and JPG files. 
   + These files _aren't_ R plots.
+ **libs**: Automatically generated files to control interactive widgets
+ **rmarkdown_and_xaringan_files**: Automatically generated files to brew the magic of a xaringan presentation.
+ **utils**: R files with a number of convenient functions

Additionally, we have the files in the home folder

+ _biblio.bib_: sample BiBTeX file 
+ _day2_summary.md_: sample markdown file
+ _README.md_: this file

## Make sure that

Make sure that you have installed the R packages

```
rmarkdown, xaringan, ggplot2, rgl, plotly, reticulate
```

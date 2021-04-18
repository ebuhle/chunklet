#'---
#'title: "Test-Driving Render-Ready R Scripts that Include External Code Chunks"
#'author: "Eric Buhle"
#'date: "`r Sys.Date()`"
#'output: html_document
#'---

#' # Render-Ready R Scripts
#' 
#' Another option is to [render a report directly](https://happygitwithr.com/r-test-drive.html) 
#' from an R script. This is great for "prettifying" R scripts with a minimum of additional effort.
#' It's also possible to use the `knitr` chunk syntax to make the same code chunks in the script
#' available to an .Rmd document via `read_chunk()`.
#' 
#' For example, the next chunk makes a plot.
#+ make_hist, fig.width = 5, out.width = "50%", fig.align = "center", message = FALSE
library(ggplot2)
ggplot(mpg, aes(hwy)) + geom_histogram() + theme_bw()

#' # Including External Code Chunks
#' 
#' Great. But we might also want to include chunks from an external script in another, renderable 
#' script. We could `source()` an external script in its entirety, but what if we just want to 
#' include a chunk or chunks from an external script instead of running the whole thing? Does
#' `read_chunk()` work in a render-ready R script? Let's find out.
#+ read_chunks
knitr::read_chunk("chunk_test1.R")

#' Now let's see if we can invoke chunks from `chunk_test1.R`.
#+ variables_xy

#' *Sweeeeeet!* It works!!! Here's some more:
#+ plot_xy, fig.width = 5, out.width = "50%", fig.align = "center", echo = FALSE
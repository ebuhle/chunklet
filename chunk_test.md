Test-Driving `knitr::read_chunk()` to Include External Script Chunks in
an RMarkdown Document
================
Eric Buhle
2021-04-18

This example follows a helpful [blog
post](http://zevross.com/blog/2014/07/09/making-use-of-external-r-code-in-knitr-and-r-markdown/)
by Zev Ross that shows how to import code chunks from an external script
into an RMarkdown document. Also see
[here](https://rpubs.com/thaufas/450838) for some more creative usage.

RMarkdown is great, but IMO it is unsuitable as an environment for code
development, especially for complex analyses. The formatting and
interwoven text are distracting and make re-running code a hassle; the
chunk tool buttons take up screen real estate and the auto-line wrapping
is the enemy of legibility; debugging is a real PITA; and I *hate* the
inline presentation of figures and output when running interactively. R
scripts are superior in all these respects. Until now, my strategy has
been to copy-paste code chunks from a script into an RMarkdown document,
a hacky approach with obvious drawbacks. Usually I end up tweaking and
refining the code in the .Rmd (as opposed to doing it in the script and
having to remember to copy-paste it again) and so the two documents get
out of sync.

The “externalization” strategy shown here offers the best of both
worlds:

-   The flexibility and interactivity of R scripts for code development
-   The power of RMarkdown as a format for literate programming and
    sharing the results of analyses

# Read chunks

First, right after the `setup` chunk, we call `knitr::read_chunk()` to
ingest the code chunks from one or more scripts. (This part is crucial:
we can read chunks from as many “child” scripts as we want, so long as
the chunk names don’t conflict!) Ordinarily we would use `echo = FALSE`
to read in the script’s chunks silently. Note that the code is not
executed at this point; it is just made available to be invoked in
subsequent chunks.

``` r
read_chunk("chunk_test1.R")
read_chunk("chunk_test2.R")
```

# Script 1

## Run the `variables_xy` chunk and use the variables it creates

``` r
x <- seq(0, 10, length = 100)
y <- x + rnorm(100)
dat <- data.frame(x = x, y = y)
head(dat)
```

              x          y
    1 0.0000000 -0.8075548
    2 0.1010101  1.7000574
    3 0.2020202 -1.6803018
    4 0.3030303  2.0597710
    5 0.4040404 -0.5295216
    6 0.5050505  1.0184619

## Run the `plot_xy` chunk and create the plot

This time we’ll use `echo = FALSE` to suppress the code.

<img src="chunk_test_files/figure-gfm/plot_xy-1.png" width="40%" style="display: block; margin: auto;" />

## Fit linear model

The next chunk shows how to fit a linear model to `y` as a function of
`x`, but doesn’t actually do so (`eval = FALSE`).

``` r
lmxy <- lm(y ~ x, data = dat)
summary(lmxy)
```

# Script 2

Now we’ll use a chunk from the second script, entirely unrelated to the
first.

## Silly `ggplot2` demo

``` r
library(ggplot2)

ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class), size = 3, alpha = 0.5) + scale_color_brewer(palette = "Dark2") + 
  theme_bw() + theme(panel.grid.minor = element_blank()) + facet_wrap(. ~ year)
```

<img src="chunk_test_files/figure-gfm/ggplot2_demo-1.png" width="75%" style="display: block; margin: auto;" />

## Chunk that requires objects defined in RMarkdown

Can we invoke an external chunk that relies on objects defined here in
the RMarkdown itself? Let’s find out. First we assign a variable
`newvar`, and then we call a chunk that prints its contents and plots it
with the default method.

``` r
newvar <- 1:10
```

``` r
print(newvar)
```

     [1]  1  2  3  4  5  6  7  8  9 10

``` r
plot(newvar)
```

<img src="chunk_test_files/figure-gfm/needs_external_input1-1.png" width="40%" style="display: block; margin: auto;" />

And what if we modify `newvar` and then call the summary chunk again?

``` r
newvar <- runif(10,0,1)
```

``` r
print(newvar)
```

     [1] 0.6957737 0.3011179 0.3423652 0.5260511 0.5815886 0.4528970 0.2621239
     [8] 0.4471303 0.7148683 0.1684800

``` r
plot(newvar)
```

<img src="chunk_test_files/figure-gfm/needs_external_input2-1.png" width="40%" style="display: block; margin: auto;" />

This works, but the plot call **only** works if we use the
`<<chunk_name>>` syntax as opposed to the `{r chunk_name}` syntax. Both
are described in the Zev Ross post linked above. If we use the latter,
the plots are identical and both use the last-defined value of `newvar`.
I don’t understand why, but it must be something about how the output
from the .Rmd code chunks are knitted together. The `<<chunk_name>>`
syntax produces an “unexpected token” warning next to the chunk in the
editor window, which is annoying, but it gives the correct plots.
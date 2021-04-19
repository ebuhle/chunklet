## @knitr variables_xy
x <- seq(0, 10, length = 100)
y <- x + rnorm(100)
dat <- data.frame(x = x, y = y)
head(dat)

## @knitr plot_xy
plot(x,y)

## @knitr
# Here is some code that is not part of a knitr chunk
# (apparently prefacing the unused chunk with an empty knitr chunk label works;
# we might also use a label like "unused" for all such chunks, which does not
# create a conflict unless the chunks are invoked, in which case the last one is used)
hist(x)

## @knitr lm_xy
lmxy <- lm(y ~ x, data = dat)
summary(lmxy)

## @knitr
# And some more code that is not part of a knitr chunk
Sys.time()

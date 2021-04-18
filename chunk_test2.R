## @knitr ggplot2_demo
library(ggplot2)

ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class), size = 3, alpha = 0.5) + scale_color_brewer(palette = "Dark2") + 
  theme_bw() + theme(panel.grid.minor = element_blank()) + facet_wrap(. ~ year)

## @knitr needs_external_input
print(newvar)
plot(newvar)
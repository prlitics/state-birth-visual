library(tidyverse)
library(ggplot2)
library(geofacet)
library(here)
library(showtext)
library(ggtext)

font_add_google("Outfit","outfit")
font_add_google("Sora","sora")

props <- readr::read_csv(file.path(here::here(),"data","props.csv"))

font_paths('C:/Users/prlic/AppData/Local/Microsoft/Windows/Fonts')
font_add('Sora',"Sora-VariableFont_wght.ttf",
         "Sora-Bold.ttf")
showtext_auto()

p<- props %>%
  ggplot()+
  aes(x = 1, y = prop, label = l, fill = as.factor(BPL_c)) +
  geom_bar(position = position_stack(reverse = TRUE), stat = 'identity') +
  geom_text(position = position_stack(reverse = TRUE, vjust = .5), color = "white",
            fontface = 'bold')+
  scale_fill_manual(name = "",
                    values = c("#677db7","#f18f01","#ff36ab"),
                    labels = c("Born in-state",
                               "Born in different US\nstate\\territory",
                               "Born outside the US")) +



  xlab("") +
  ylab("") +
  facet_geo(~state) +
  labs(title = "Which states have the highest proportion of residents born <span style = 'color:#677db7;'><strong>in-state,</strong></span>
       <br> from <span style = 'color:#f18f01;'><strong>somewhere else in the US,</strong></span> or <span style = 'color:#ff36ab;'><strong>outside the US? </strong></span>
       <br>",

  subtitle = "<span style = 'color:#677db7;'><strong>Louisiana</strong></span> has the highest  proportion of residents born in-state.<br>
       <span style = 'color:#f18f01;'><strong>Wyoming </strong></span> has the highest  proportion born elsewhere within the US and its territories.<br>
       <span style = 'color:#ff36ab;'><strong>California </strong></span> has the highest proportion born outside the US.<br>",
    caption = "Raw Data Source: 2017-2021 5 Year ACS (<i>via</i> IPUMS)<br>Analysis and Plot by Peter Licari")+
  theme(text = element_text('Sora'),
        strip.background = element_rect(fill = NA,
                                        color = 'black'),
        strip.text = element_text(face = 'bold'),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.position = 'top',
        legend.text = element_text(family = 'Sora'),
        panel.background = element_blank(),
        plot.caption = element_markdown(color = '#8a8d91'),
        plot.subtitle = element_markdown(hjust = .5),
        plot.title = element_markdown(hjust = .5, size = 24)


        )

# ggsave(file.path(here::here(),"outputs","final.png"),
#        p,
#        width = 8,
#        height = 6,
#        units = "in")





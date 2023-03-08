## Working out the decay rate from 2019-2023
library(ggplot2)
library(gridExtra)
library(hrbrthemes)
satcat_above_2019$DECAY_DATE <- as.Date(satcat_above_2019$DECAY_DATE)
satcat_above_2019_has_decayed <- satcat_above_2019[satcat_above_2019$DECAY_DATE > '2019-01-01' & satcat_above_2019$DECAY_DATE < '2023-01-01' & !is.na(satcat_above_2019$DECAY_DATE),]
satcat_above_2019_has_decayed$DECAY_DATE <- as.Date(satcat_above_2019_has_decayed$DECAY_DATE)

fsp_above_2019_has_decayed <- fsp_above_2019[fsp_above_2019$DECAY_DATE > '2019-01-01' & fsp_above_2019$DECAY_DATE < '2023-01-01',]
fsp_above_2019_has_decayed$DECAY_DATE <- as.Date(fsp_above_2019_has_decayed$DECAY_DATE)
fsp_above_2019_has_decayed$OWNER <- fsp_above_2019_has_decayed$SOURCE

q1 <- ggplot(data=satcat_above_2019_has_decayed, aes(x=DECAY_DATE, fill=OWNER)) +
  geom_histogram() +
  ylim(0, 50) +
  labs(x="SATCAT", y="Number of Objects")


q2 <- ggplot(data=fsp_above_2019_has_decayed, aes(x=DECAY_DATE, fill=SOURCE)) +
  geom_histogram() +
  ylim(0, 50) +
  labs(x="FSP", y="Number of Objects")

p <- ggplot() +
  geom_histogram(data = satcat_above_2019_has_decayed, aes(x=DECAY_DATE, fill=OWNER)) +
  geom_histogram(data = fsp_above_2019_has_decayed, aes(x=DECAY_DATE, fill=OWNER)) +
  scale_fill_discrete(name = "OWNER") +
  theme(legend.position = "bottom")

p

g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

mylegend<-g_legend(p)

# Arrange the plots vertically with a shared legend
grid.arrange(arrangeGrob(q1 + theme(legend.position="none"),
                         q2 + theme(legend.position="none"),
                         nrow=1),
             mylegend, nrow=2,heights=c(8, 1))



## 2043

fsp_2043_decayed <- fsp_2043[fsp_2043$DECAY_DATE > '2019-01-01',]
fsp_2043_decayed$DECAY_DATE <- as.Date(fsp_2043_decayed$DECAY_DATE)

ggplot(data=fsp_2043_decayed, aes(x=DECAY_DATE)) +
  geom_histogram(binwidth = 5, fill="#69b3a2", color="lightblue", alpha=0.9) +
  labs(x="FSP", y="Number of Objects", title="Decay Rate from 2019-2043")


merge_for_plot <- merge(fsp_launches_per_year, satcat_launches_per_year, by = "year")

ggplot(merge_for_plot, aes(year)) +
  geom_line(aes(y = n.x, colour = "FSP")) + 
  geom_line(aes(y = n.y, colour = "Satcat"))

# https://dominicroye.github.io/en/2018/how-to-create-warming-stripes-in-r/
theme_strip <- theme_minimal() +
  theme(axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.title = element_blank(),
        panel.grid.major = element_blank(),
        legend.title = element_blank(),
        axis.text.x = element_text(vjust = 3),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 14, face = "bold")
  )


col_strip <- brewer.pal(11, "RdBu")
brewer.pal.info

ggplot(fsp_launches_per_year, aes(x = year, y = 1, fill = n)) +
  geom_tile() +
  scale_y_continuous(expand = c(0, 0)) +
  scale_fill_gradientn(colors = rev(col_strip))+
  guides(fill = guide_colorbar(barwidth = 1)) +
  labs(title = "Count of Launched Orbital Objects per year (1957-2022)",
       caption = "Data Source: Celestrak, 2022")+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme_strip

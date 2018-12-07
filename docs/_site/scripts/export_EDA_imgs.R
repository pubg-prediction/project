# Plot separate ggplot figures in a loop.
# Must load objects from pred_model.RMD
library(ggplot2)

# data
filter_vars = c("boosts", "damage_dealt", "headshot_kills", "heals", "kills", "longest_kill", "ride_distance", "swim_distance", "walk_distance", "weapons_acquired")
tmp_dat <- train_solo %>% 
  filter_at(vars(filter_vars), all_vars(. < quantile(., 0.99, na.rm = T))) %>%   # Remove outliers
  mutate(win_place_cat = floor(win_place_perc / 0.2),
         win_place_cat = ifelse(win_place_cat == 5, 4, win_place_cat),
         win_place_cat = as.factor(win_place_cat))
  
# Make list of variable names to loop over.
var_list = tmp_dat %>% select(-match_id, -match_duration, -id, -win_place_perc, -win_place_cat) %>% colnames()

# Make plots.
plot_list = list()
for (i in 1:length(var_list)) {
  p =  ggplot(tmp_dat, aes_string(x = var_list[i], color = "win_place_cat")) +
    geom_density() +
    labs(title = paste0("Distribution of ", var_list[i], " by finish percentile"), 
         x = var_list[[i]][1], y = "Density", color = "Percentile") +
  scale_color_manual(labels = c("0-19", "20-39", "40-59", "60-79", "80-100"),
                     values = brewer.pal(5, "OrRd")) +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1), 
        plot.title = element_text(size = 12))
  
  plot_list[[i]] = p
}

# Save plots to png Makes a separate file for each plot.
for (i in 1:length(var_list)) {
  file_name = paste("data_plot_", i, ".png", sep="")
  png(file_name, width = 300, height = 300, units = "px")
  print(plot_list[[i]])
  dev.off()
}
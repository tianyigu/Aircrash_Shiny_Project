library(plotly)

# read in data
df <- read.csv("gro_noarm.csv", stringsAsFactors = F)
df$Ratio[99]
df = df[!df$X==99,]



# Arrange in increasing order of ratio
df <- df %>% dplyr::arrange(count)
df <- df[-(1:2120),]
df = df %>% mutate(Ratio_range = ifelse(Ratio < 0.35, "(0-0.35)", ifelse(Ratio >= 0.35 & Ratio<0.7 , "(0.35-0.7)", ifelse(Ratio >= 0.7 & Ratio<0.85, "(0.7-0.85)", "(0.85-1)"))))
#  Add colors
colors <- RColorBrewer::brewer.pal(length(unique(df$Ratio_range)), "Spectral")
Ratio_range <- unique(df$Ratio_range)

df$colors <- df$Ratio_range

for(i in 1:length(Ratio_range)){
  idx <- df$colors %in% Ratio_range[i]   
  df$colors[idx] <- colors[i]
}

# Get incremental angle value
n <- nrow(df) + 20
dtheta <- 2*pi / n
theta <- pi / 2

# Initialise
x <- c()
y <- c()
xend <- c()
yend <- c()

# This is for the white - circle in the middle
adjust <- 20

# Calculate x and y coordinates
for(ctr in 1:nrow(df)){
  
  a <- df$count[ctr] + adjust
  
  x[ctr] <- adjust * cos(theta)
  y[ctr] <- adjust * sin(theta)
  
  xend[ctr] <- a * cos(theta)
  yend[ctr] <- a * sin(theta)
  
  theta <- theta + dtheta
}


plot.df <- data.frame(x, y, xend, yend, Ratio_range = df$Ratio_range)

p <- plot_ly(plot.df, 
             x = ~x, y = ~y,
             xend = ~xend, yend = ~yend,
             color = ~Ratio_range) %>% 
  add_segments(line = list(width = 5))

# Add layout options, shapes etc
p <- layout(p,
            xaxis = list(domain = c(0, 0.7), title = "", showgrid = F, zeroline = F, showticklabels = F),
            yaxis = list(title = "", showgrid = F, zeroline = F, showticklabels = F),
            shapes = list(
              list(type = "circle",
                   x0 = (-5 - adjust),
                   y0 = (-5 - adjust),
                   x1 = (5 + adjust),
                   y1 = (5 + adjust),
                   fillcolor = "transparent",
                   line = list(color = '#282B30', width = 2)),
              
              list(type = "circle",
                   x0 = (-15 - adjust),
                   y0 = (-15 - adjust),
                   x1 = (15 + adjust),
                   y1 = (15 + adjust),
                   fillcolor = "transparent",
                   line = list(color = '#282B30', width = 2)),
              
              list(type = "circle",
                   x0 = (-25 - adjust),
                   y0 = (-25 - adjust),
                   x1 = (25 + adjust),
                   y1 = (25 + adjust),
                   fillcolor = "transparent",
                   line = list(color = '#282B30', width = 2)),
              
              list(type = "circle",
                   x0 = (-35 - adjust),
                   y0 = (-35 - adjust),
                   x1 = (35 + adjust),
                   y1 = (35 + adjust),
                   fillcolor = "transparent",
                   line = list(color = "#282B30", width = 2))),
            
            legend = list(x = -5, y = 17, font = list(size = 10,color = "#989898")))

# Add annotations for country names
theta <- pi / 2
textangle <- 90

for(ctr in 1:nrow(df)){
  
  a <- df$count[ctr] + adjust
  a <- a + a/12
  
  x <- a * cos(theta)
  y <- a * sin(theta)
  
  if(ctr < 51) {xanchor <- "right"; yanchor <- "middle"}
  if(ctr > 51 & ctr < 84) {xanchor <- "right"; yanchor <- "middle"}
  if(ctr > 84) {xanchor <- "left"; yanchor <- "middle"}
  
  p$x$layout$annotations[[ctr]] <- list(x = x, y = y, showarrow = F,
                                        text = paste0(df$Operator[ctr]),
                                        textangle = textangle,
                                        xanchor = xanchor,
                                        yanchor = yanchor,
                                        font = list(family = "serif", size = 6,color = "#989898"),
                                        borderpad = 0,
                                        borderwidth = 0)
  theta <- theta + dtheta
  textangle <- textangle - (180 / pi * dtheta)
  
  if(textangle < -90) textangle <- 90
}

# Titles and some other details
#p$x$layout$annotations[[148]] <- list(xref = "paper", yref = "paper",
 #                                     x = 0, y = 1, showarrow = F,
#                                      xanxhor = "left", yanchor = "top",
 #                                     align = "left",
 #                                     text = "<em>Aircrash count by Airline</em><br><sup></sup>",
 #                                     font = list(size = 25, color = "black"))



p$x$layout$annotations[[150]] <- list(xref = "paper", yref = "paper",
                                      x = -0.25, y = 1.46, showarrow = F,
                                      xanxhor = "left", yanchor = "top",
                                      align = "left",
                                      text = "Death Ratio",
                                      font = list(size = 12, color = "#989898"))
p = p %>% layout(plot_bgcolor='rgb(40, 43, 48)') %>% 
  layout(paper_bgcolor='rgb(40, 43, 48)')%>%
  layout(title = "Aircrash count and death ratio by Airline in history",font = list(color = "#989898"))
p


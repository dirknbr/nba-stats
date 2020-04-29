
library(ggplot2)
library(dplyr)

data <- read.csv('data.csv', stringsAsFactors = F, header = F)
names(data) <- c('year', 'wl', 'team')

split <- function(x, idx = 1) {
	return(as.numeric(unlist(strsplit(x, "-"))[idx]))
}

split('1-1')

data$win <- sapply(data$wl, split)
data$loss <- sapply(data$wl, split, idx = 2)
data$games <- data$win + data$loss
data$win_pc <- data$win / data$games
data$rank <- 1

for (i in 2:nrow(data)) {
	if (data$year[i] == data$year[i - 1]) {
		data$rank[i] <- data$rank[i - 1] + 1
	}
}

summary(data)

sorted <- arrange(dplyr::summarise(group_by(data, team), wins = sum(win), 
	win_pc = sum(wins) / sum(games), mean_rank = mean(rank)), desc(win_pc))
write.csv(sorted, 'sorted.csv')
sorted

top <- head(sorted, 7)

ggplot(data[data$team %in% top$team, ], aes(x = year, y = win_pc, group = team, colour = team)) + geom_line()

ggplot(data[data$team %in% c('CHI', 'LAL', 'GSW', 'BOS', 'MIL'), ], 
	aes(x = year, y = win_pc, group = team, colour = team)) + geom_line()

ggplot(data[data$team %in% c('CHI', 'LAL', 'GSW', 'BOS', 'MIL'), ], 
	aes(x = year, y = rank, group = team, colour = team)) + geom_line() + scale_y_reverse()
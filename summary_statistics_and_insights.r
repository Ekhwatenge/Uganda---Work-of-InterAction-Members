# Load necessary libraries
library(tidyverse)
library(lubridate)

# Read the data
data <- read.csv("member_data_uga.csv", stringsAsFactors = FALSE)

# Clean up the data
data <- data %>%
  filter(Title != "#activity+title") %>%
  mutate(Date = ymd(Date),
         Year = year(Date))

# Summary statistics
summary_stats <- summary(data)

# Activities by funding type
funding_type_count <- data %>%
  count('Funding Type') %>%
  arrange(desc(n))

# Activities by sector
sector_count <- data %>%
  separate_rows(Sectors, sep = ", ") %>%
  count(Sectors) %>%
  arrange(desc(n))

# Activities by year
year_count <- data %>%
  count(Year) %>%
  arrange(desc(n))

# Visualizations
# 1. Activities by funding type
ggplot(funding_type_count, aes(x = reorder('Funding Type', -n), y = n)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(title = "Activities by Funding Type",
       x = "Funding Type",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("activities_by_funding_type.png", width = 8, height = 6)

# 2. Activities by sector
ggplot(sector_count, aes(x = reorder(Sectors, -n), y = n)) +
  geom_bar(stat = "identity", fill = "lightgreen") +
  theme_minimal() +
  labs(title = "Activities by Sector",
       x = "Sector",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("activities_by_sector.png", width = 10, height = 6)

# 3. Activities by year
ggplot(year_count, aes(x = Year, y = n)) +
  geom_bar(stat = "identity", fill = "salmon") +
  theme_minimal() +
  labs(title = "Activities by Year",
       x = "Year",
       y = "Count")

ggsave("activities_by_year.png", width = 8, height = 6)

# Save summary statistics and insights
sink("summary_statistics_and_insights.txt")
cat("Summary Statistics:\n")
print(summary_stats)
cat("\n\nActivities by Funding Type:\n")
print(funding_type_count)
cat("\n\nActivities by Sector:\n")
print(sector_count)
cat("\n\nActivities by Year:\n")
print(year_count)
sink()



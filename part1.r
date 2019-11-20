## ------------------------------------------------------------------------
install.packages("tidyverse", repos = "http://cran.us.r-project.org")
library("tidyverse")

survey <- read_csv("https://raw.githubusercontent.com/introdsci/MusicSurvey/master/music-survey.csv")
preferences <- read_csv("https://raw.githubusercontent.com/introdsci/MusicSurvey/master/preferences-survey.csv")


## ------------------------------------------------------------------------
colnames(survey)[colnames(survey)=="Timestamp"] <- "time_submitted"
colnames(survey)[colnames(survey)=="First, we are going to create a pseudonym for you to keep this survey anonymous (more or less). Which pseudonym generator would you prefer?"] <- "pseudonym_generator"
colnames(survey)[colnames(survey)=="What is your pseudonym?"] <- "pseudonym"
colnames(survey)[colnames(survey)=="Sex"] <- "sex"
colnames(survey)[colnames(survey)=="Major"] <- "academic_major"
colnames(survey)[colnames(survey)=="Academic Year"] <- "academic_level"
colnames(survey)[colnames(survey)=="Year you were born (YYYY)"] <- "year_born"
colnames(survey)[colnames(survey)=="Which musical instruments/talents do you play? (Select all that apply)"] <- "instrument_list"
colnames(survey)[colnames(survey)=="Artist"] <- "favorite_song_artist"
colnames(survey)[colnames(survey)=="Song"] <- "favortie_song"
colnames(survey)[colnames(survey)=="Link to song (on Youtube or Vimeo)"] <- "favorite_song_link"


## ------------------------------------------------------------------------
library("dplyr")
library("tidyr")

Person <- tibble(pseudonym=survey$pseudonym, academic_level=survey$academic_level, academic_major=survey$academic_major, time_submitted=survey$time_submitted, favorite_song_artist=survey$favorite_song_artist, favorite_song=survey$favortie_song, favorite_song_link=survey$favorite_song_link)

FavoriteSong <- tibble(pseudonym=survey$pseudonym, favorite_song_artist=survey$favorite_song_artist, favorite_song=survey$favortie_song, favorite_song_link=survey$favorite_song_link)

Ratings <- gather(preferences, "artist_song", "rating", 3:45)


## ------------------------------------------------------------------------
colnames(Ratings)[colnames(Ratings) == "What was your pseudonym?"] <- "pseudonym"
colnames(preferences)[colnames(preferences) == "What was your pseudonym?"] <- "pseudonym"
colnames(Ratings)[colnames(Ratings) == "Timestamp"] <- "time_submitted"
colnames(preferences)[colnames(preferences) == "Timestamp"] <- "time_submitted"


## ------------------------------------------------------------------------
Person$time_submitted <- as.POSIXlt(parse_datetime(Person$time_submitted, format = "%m/%d/%y %H:%M"))
Ratings$time_submitted <- as.POSIXlt(parse_datetime(Ratings$time_submitted, format = "%m/%d/%y %H:%M"))


## ------------------------------------------------------------------------
Person$academic_level <- as.factor(Person$academic_level)
levels(Person$academic_level)
Person$academic_major <- as.factor(Person$academic_major)
levels(Person$academic_major)
FavoriteSong$pseudonym <- as.factor(FavoriteSong$pseudonym)
Ratings$pseudonym <- as.factor(Ratings$pseudonym)
FavoriteSong$favorite_song <- as.factor(FavoriteSong$favorite_song)


## ------------------------------------------------------------------------
library("ggplot2")
f <- ggplot(Ratings, aes(artist_song, rating))
f + geom_col()
e <- ggplot(Ratings, aes(x=rating))
e + geom_histogram(binwidth = 1)
ggplot(Ratings, aes(x=rating, y=pseudonym)) + geom_boxplot()


## ------------------------------------------------------------------------
fix_rating <- select(Ratings, -time_submitted)


## ------------------------------------------------------------------------
# filter(dplyr::right_join(fix_rating, FavoriteSong, by="pseudonym"))
favorite_rating <- fix_rating %>%
  left_join(FavoriteSong, by="pseudonym") %>%
  filter(artist_song==paste(favorite_song_artist,favorite_song)) %>%
  select(pseudonym, artist_song, rating)
print(favorite_rating)


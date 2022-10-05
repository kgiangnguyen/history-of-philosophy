# ADS Project 1:  R Notebook on the history of philosophy

### Output folder

The output directory contains analysis output, processed datasets, logs, or other processed things.

* `philosophy_data_table.csv`: the original dataset was saved as a `data.table` object in order to decrease run time when reading the data
* `emotions.csv`: the processed data after applying sentiment analysis, including the original columns and 10 additional columns of word count per sentence representing each emotion analyzed (anger, fear, anticipation, trust, surprise, sadness, joy, disgust, positive, negative)
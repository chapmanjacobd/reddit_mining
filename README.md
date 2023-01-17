# reddit_mining

## List of Subreddits

### Downloads

The most interesting files are likely going to be [top_link_subreddits.csv](./top_link_subreddits.csv) and [top_text_subreddits.csv](./top_text_subreddits.csv).

The files starting with long_* and nsfw_* contain the same data -- they are just sorted differently. Check [insights.md](./insights.md) for more details.

## How was this made?

Today we will look at [subreddits](https://youtu.be/pUncXbXAiV0). The data aggregates loaded here were created by converting pushshift [RS\*.zst](https://files.pushshift.io/reddit/submissions/) data into SQLITE format using the pushshift subcommand of the [xklb](https://github.com/chapmanjacobd/library) python package:

```fish
wget -e robots=off -r -k -A zst https://files.pushshift.io/reddit/submissions/

pip install xklb

for f in psaw/files.pushshift.io/reddit/submissions/*
    echo "unzstd --memory=2048MB --stdout $f | library pushshift (basename $f).db"
end | parallel -j4

library merge submissions.db psaw/RS*.db
```

This takes several days per step (and several terabytes of free space) but the end result is a 600 GB SQLITE file. You can save some disk space by downloading the parquet files below.

I split up the data into two parquet files via [sqlite2parquet](https://github.com/asayers/sqlite2parquet/).

Query the Parquet files using `octosql`. Depending on the query, `octosql` is usually faster than SQLITE and parquet compresses very well. You may download those parquet files here:

1) [reddit_links.parquet](https://archive.org/details/reddit_links) [87.7G]
2) [reddit_posts.parquet](https://archive.org/details/reddit_posts) [~134G]

Additionally, for simple analysis you can get by with downloading the sub-100MB pre-aggregated files in this repo. For the sake of speed, the ideal of having clearly defined experimental variables, I have bifurcated the aggregations based on the type of post into two types of files:

1) 'link' for traditional reddit posts.
2) 'text' posts (aka selftext; which were [introduced in 2008](https://news.ycombinator.com/item?id=20453120)).

## Misc

### user_stats_link.csv

user_stats_link.csv.zstd was 150MB so I split it up into three files like this:

```sh
split -d -C 250MB user_stats_link.csv user_stats_link_
zstd -19 user_stats_link_*
```

You can combine it back to one file like this:

```sh
zstdcat user_stats_link_*.zstd > user_stats_link.csv
```

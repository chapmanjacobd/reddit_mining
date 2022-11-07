# reddit_mining

Today we will look at [subreddits](https://youtu.be/pUncXbXAiV0). The data aggregates loaded here were created by converting pushshift [RS\*.zst](https://files.pushshift.io/reddit/submissions/) data into SQLITE format using the pushshift subcommand of the [xklb](https://github.com/chapmanjacobd/library) python package:

```fish
wget -e robots=off -r -k -A zst https://files.pushshift.io/reddit/submissions/

pip install xklb

for f in psaw/files.pushshift.io/reddit/submissions/*
    echo "unzstd --memory=2048MB --stdout $f | library pushshift (basename $f).db"
end | parallel -j4

library merge submissions.db psaw/RS*.db

# This takes several days per step and several terabytes but the end result is a 600 GB SQLITE file
```

But for simple analysis you can get by with downloading the sub-100MB pre-aggregated files in this repo. For the sake of simplicity, speed, the platonic ideal of clearly defining experimental variables, and because SQLITE does not support FULL OUTER JOINs in the version of Fedora that I use, I have separated the aggregations based on the type of post into two files:

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

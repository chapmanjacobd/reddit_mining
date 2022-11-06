# reddit_mining

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

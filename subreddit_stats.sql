-- this takes about 8 hours to run
CREATE TABLE subreddit_stats_link AS
SELECT
    playlist_path subreddit,
    MIN(time_created) oldest,
    CAST(AVG(time_created) AS INT) avg_age,
    MAX(time_created) latest,
    CAST(AVG(NULLIF(time_modified, 0) - time_created) AS INT) avg_time_to_edit,
    MIN(score) min_score,
    AVG(score) avg_score,
    MAX(score) max_score,
    AVG(num_comments) avg_comments,
    MAX(num_comments) max_comments,
    AVG(num_crossposts) avg_crossposts,
    COUNT(path) COUNT,
    COUNT(
        DISTINCT author
    ) count_authors,
    AVG(LENGTH(path)) avg_length,
    AVG(LENGTH(title)) avg_length_title,
    AVG(COALESCE(upvote_ratio, 0)) avg_upvote_ratio,
    AVG(COALESCE(is_over_18, 0)) is_over_18_ratio
FROM
    media
GROUP BY
    subreddit;

CREATE TABLE subreddit_stats_text AS
SELECT
    playlist_path subreddit,
    MIN(time_created) oldest,
    CAST(AVG(time_created) AS INT) avg_age,
    MAX(time_created) latest,
    CAST(AVG(time_created - NULLIF(time_modified, 0)) AS INT) avg_time_to_edit,
    MIN(score) min_score,
    AVG(score) avg_score,
    MAX(score) max_score,
    AVG(num_comments) avg_comments,
    MAX(num_comments) max_comments,
    AVG(num_crossposts) avg_crossposts,
    COUNT(path) COUNT,
    COUNT(
        DISTINCT author
    ) count_authors,
    AVG(LENGTH(selftext)) avg_length,
    AVG(LENGTH(title)) avg_length_title,
    AVG(COALESCE(upvote_ratio, 0)) avg_upvote_ratio,
    AVG(COALESCE(is_over_18, 0)) is_over_18_ratio
FROM
    reddit_posts
GROUP BY
    subreddit;

-- sqlite-utils rows --csv reddit/submissions.db subreddit_stats_link >~/github/xk/reddit_mining/subreddit_stats_link.csv

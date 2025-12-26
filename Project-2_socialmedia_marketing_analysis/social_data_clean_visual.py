# 1) IMPORT LIBRARIES
import pandas as pd
import matplotlib.pyplot as plt

# ---------------------------------
# 2) LOAD DATA
# ---------------------------------
df = pd.read_csv("C:/Users/dimpl/OneDrive/Documents/Data_analyis/social_media_dataset.csv")
df.head()

# ---------------------------------
# 3) BASIC CHECKS
# ---------------------------------
print(df.info())
print(df.describe())
print(df.isnull().sum())
##print(df.columns.tolist())

# ---------------------------------
# 4) REMOVE UNNECESSARY COLUMNS
# ---------------------------------
cols_to_drop = [
    "content_url", "content_description", "hashtags",
    "comments_text", "creator_name", "sponsor_name",
    "disclosure_location", "id"]
df = df.drop(columns=cols_to_drop, errors="ignore")

# ---------------------------------
# 5) FIX DATA TYPES
# ---------------------------------
df["post_date"] = pd.to_datetime(
    df["post_date"],
    format="%m/%d/%y %I:%M %p",
    errors="coerce")
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
##print(df)

# ---------------------------------
# 6) CREATE NEW METRICS
# ---------------------------------
df["engagement_rate"] = (df["likes"] + df["shares"] + df["comments_count"]) / df["views"]
##print(df)
# ---------------------------------
# 7) GROUPING & SUMMARY TABLES
# ---------------------------------

##Platform-wise engagement
platform_eng = df.groupby("platform")["engagement_rate"].mean()

##Content type performance
content_type_perf = df.groupby(["platform", "content_type"])["views"].mean()

##Sponsored vs organic comparison
sponsor_perf = df.groupby("is_sponsored")["engagement_rate"].mean()
##print(df)
# ---------------------------------
# 8) VISUALIZATIONS
# ---------------------------------

##1) Engagement by platform
colors = ["red", "green", "yellow", "blue", "pink"]
platform_eng.plot(kind="bar" , color = colors)
plt.title("Engagement Rate by Platform")
plt.xlabel("Platform")
plt.ylabel("Engagement Rate")
##plt.show()

import seaborn as sns

df["hour"] = df["post_date"].dt.hour
heat = df.pivot_table(values="likes", index="platform", columns="hour", aggfunc="mean")

plt.figure(figsize=(12,6))
sns.heatmap(heat, cmap="viridis")
plt.title("Engagement Heatmap (Platform × Hour)")
##plt.show()

df["month"] = df["post_date"].dt.to_period("M").astype(str)
trend = df.groupby(["month", "platform"])["likes"].sum().reset_index()

plt.figure(figsize=(12,6))

for p in trend["platform"].unique():
    subset = trend[trend["platform"] == p]
    plt.plot(subset["month"], subset["likes"], marker="o", label=p)

plt.xlabel("Month")
plt.ylabel("Total Likes")
plt.title("Monthly Likes Trend by Platform")

plt.xticks(rotation=45)
plt.legend()
plt.tight_layout()
##plt.show()

plt.figure(figsize=(10,5))
sns.boxplot(data=df, x="platform", y="views")
plt.title("Views Outlier Distribution by Platform")
plt.xticks(rotation=45)
##plt.show()

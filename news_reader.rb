#! /usr/bin/ruby

require 'rss/1.0'
require 'rss/2.0'

def show_feeds(feeds)
  feeds.each do |feed|
    puts feed.channel.title
    
    feed.items.sort! {|a,b| b.date <=> a.date}
    
    feed.items.each do |item|
      puts "\t- #{item.title}"
    end
  end
end

def feed_display_str(feed)
  feed_str = feed.channel.title + "\n"
  feed.items.each do |item|
    feed_str << "\t- #{item.title}\n"
  end
  feed_str
end

# Dispatch a thread to return the parsed feed object from each feed url, return an array of Feeds
def fetch_feeds_from_urls(feed_urls)
  threads = []
  feeds = []
  feed_urls.each do |feed_url|
    threads << Thread.new {
      feeds << RSS::Parser.parse(feed_url, false)
    }
  end
  threads.each {|t| t.join}
  feeds
end

def fetch_feed_strings_from_urls(feed_urls)
  threads = []
  feeds = []
  feed_urls.each do |feed_url|
    threads << Thread.new {
      feeds << feed_display_str(RSS::Parser.parse(feed_url, false))
    }
  end
  threads.each {|t| t.join}
  feeds.join "\n"
end

news_feed_urls =  [
                "http://images.apple.com/main/rss/hotnews/hotnews.rss",
                "http://bspaulding.posterous.com/rss.xml",
                "http://news.google.com/news?pz=1&ned=us&hl=en&output=rss",
                "http://feeds.delicious.com/v2/rss/brad.spaulding?count=15",
                "http://benwitherington.blogspot.com/feeds/posts/default?alt=rss",
                "http://blog.pandora.com/pandora/index.xml",
                "http://www.rollingstone.com/rssxml/music_news.xml?bid=782298053",
                "http://www.youtube.com/rss/global/our_blog.rss",
                "http://www.classicalarchives.com/news.xml",
                "http://www.engadget.com/rss.xml",
                "http://news.com.com/2547-1_3-0-5.xml",
                "http://twitter.com/statuses/public_timeline.rss"
              ]


#show_feeds(fetch_feeds_from_urls(news_feed_urls))

puts fetch_feed_strings_from_urls(news_feed_urls)
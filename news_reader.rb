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

news_feed_urls =  [
                "http://images.apple.com/main/rss/hotnews/hotnews.rss",
                "http://bspaulding.posterous.com/rss.xml"
              ]


show_feeds(fetch_feeds_from_urls(news_feed_urls))
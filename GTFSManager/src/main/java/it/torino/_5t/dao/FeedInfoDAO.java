package it.torino._5t.dao;

import it.torino._5t.entity.FeedInfo;

import java.util.List;

public interface FeedInfoDAO {
	public List<FeedInfo> getAllFeedInfos();
	public FeedInfo getFeedInfo(Integer id);
	public void addFeedInfo(FeedInfo feedInfo);
	public void deleteFeedInfo(FeedInfo feedInfo);
}

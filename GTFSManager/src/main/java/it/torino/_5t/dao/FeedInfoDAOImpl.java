package it.torino._5t.dao;

import it.torino._5t.entity.FeedInfo;
import it.torino._5t.persistence.HibernateUtil;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

public class FeedInfoDAOImpl implements FeedInfoDAO {

	@Override
	public List<FeedInfo> getAllFeedInfos() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from FeedInfo");
		return query.list();
	}

	@Override
	public FeedInfo getFeedInfo(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from FeedInfo where id = :id");
		query.setInteger("id", id);
		List<FeedInfo> feedInfos = new ArrayList<FeedInfo>();
		feedInfos = query.list();
		if (feedInfos.size() > 0) {
			return feedInfos.get(0);
		}
		return null;
	}

	@Override
	public void addFeedInfo(FeedInfo feedInfo) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(feedInfo);
	}

	@Override
	public void deleteFeedInfo(FeedInfo feedInfo) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.delete(feedInfo);
	}

}

package it.torino._5t.dao;

import it.torino._5t.entity.FeedInfo;
import it.torino._5t.persistence.HibernateUtil;

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

}

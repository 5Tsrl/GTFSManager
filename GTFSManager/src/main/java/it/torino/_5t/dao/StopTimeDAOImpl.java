package it.torino._5t.dao;

import it.torino._5t.entity.StopTime;
import it.torino._5t.persistence.HibernateUtil;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

public class StopTimeDAOImpl implements StopTimeDAO {

	@Override
	public List<StopTime> getAllStopTimes() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from StopTime");
		return query.list();
	}

	@Override
	public StopTime getStopTime(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from StopTime where id = :id");
		query.setInteger("id", id);
		List<StopTime> stopTimes = new ArrayList<StopTime>();
		stopTimes = query.list();
		if (stopTimes.size() > 0) {
			return stopTimes.get(0);
		}
		return null;
	}

	@Override
	public void addStopTime(StopTime stopTime) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(stopTime);
	}

}

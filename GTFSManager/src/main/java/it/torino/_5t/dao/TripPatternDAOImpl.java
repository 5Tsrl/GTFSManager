package it.torino._5t.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import it.torino._5t.entity.TripPattern;
import it.torino._5t.persistence.HibernateUtil;

public class TripPatternDAOImpl implements TripPatternDAO {

	@Override
	public TripPattern getTripPattern(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from TripPattern where id = :id");
		query.setInteger("id", id);
		List<TripPattern> tripPatterns = new ArrayList<TripPattern>();
		tripPatterns = query.list();
		if (tripPatterns.size() > 0) {
			return tripPatterns.get(0);
		}
		return null;
	}

	@Override
	public void updateTripPattern(TripPattern tripPattern) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(tripPattern);
	}

	@Override
	public List<TripPattern> getAllTripPatterns() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from TripPattern");
		return query.list();
	}

}

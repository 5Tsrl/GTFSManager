package it.torino._5t.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import it.torino._5t.entity.Trip;
import it.torino._5t.persistence.HibernateUtil;

public class TripDAOImpl implements TripDAO {

	@Override
	public void addTrip(Trip trip) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(trip);
	}

	@Override
	public void updateTrip(Trip trip) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(trip);
	}

	@Override
	public void deleteTrip(Trip trip) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.delete(trip);
	}

	@Override
	public Trip getTrip(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Trip where id = :id");
		query.setInteger("id", id);
		List<Trip> trips = new ArrayList<Trip>();
		trips = query.list();
		if (trips.size() > 0) {
			return trips.get(0);
		}
		return null;
	}

	@Override
	public Trip loadTrip(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		return (Trip) session.load(Trip.class, id);
	}

	@Override
	public List<Trip> getAllTrips() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Trip");
		return query.list();
	}

}

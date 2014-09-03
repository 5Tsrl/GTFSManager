package it.torino._5t.dao;

import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Stop;
import it.torino._5t.persistence.HibernateUtil;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

public class StopDAOImpl implements StopDAO {

	@Override
	public List<Stop> getAllStops() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Stop");
		return query.list();
	}

	@Override
	public Stop getStop(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Stop where id = :id");
		query.setInteger("id", id);
		List<Stop> stops = new ArrayList<Stop>();
		stops = query.list();
		if (stops.size() > 0) {
			return stops.get(0);
		}
		return null;
	}

	@Override
	public List<Stop> getStopsFromAgency(Agency agency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Stop where agency = :agency");
		query.setEntity("agency", agency);
		return query.list();
	}

}

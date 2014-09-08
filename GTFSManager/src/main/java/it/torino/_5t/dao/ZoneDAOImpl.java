package it.torino._5t.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import it.torino._5t.entity.Zone;
import it.torino._5t.persistence.HibernateUtil;

public class ZoneDAOImpl implements ZoneDAO {

	@Override
	public Zone getZone(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Zone where id = :id");
		query.setInteger("id", id);
		List<Zone> zones = new ArrayList<Zone>();
		zones = query.list();
		if (zones.size() > 0) {
			return zones.get(0);
		}
		return null;
	}

	@Override
	public void updateZone(Zone zone) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(zone);
	}

}

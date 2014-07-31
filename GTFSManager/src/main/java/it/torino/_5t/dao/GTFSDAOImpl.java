package it.torino._5t.dao;

import it.torino._5t.entity.GTFS;
import it.torino._5t.persistence.HibernateUtil;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

public class GTFSDAOImpl implements GTFSDAO {

	@Override
	public List<GTFS> getAllGTFSs() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from GTFS");
		return query.list();
	}

	@Override
	public GTFS getGTFS(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from GTFS where id = :id");
		query.setInteger("id", id);
		List<GTFS> gtfss = new ArrayList<GTFS>();
		gtfss = query.list();
		if (gtfss.size() > 0) {
			return gtfss.get(0);
		}
		return null;
	}

	@Override
	public void deleteGTFS(GTFS gtfs) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.delete(gtfs);
	}

	@Override
	public void addGTFS(GTFS gtfs) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(gtfs);
	}

}

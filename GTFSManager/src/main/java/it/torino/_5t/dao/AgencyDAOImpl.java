package it.torino._5t.dao;

import it.torino._5t.entity.Agency;
import it.torino._5t.persistence.HibernateUtil;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

public class AgencyDAOImpl implements AgencyDAO {

	@Override
	public void addAgency(Agency agency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(agency);
	}

	@Override
	public List<Agency> getAllAgencies() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Agency");
		return query.list();
	}

	@Override
	public Agency getAgency(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Agency where id = :id");
		query.setInteger("id", id);
		List<Agency> agencies = new ArrayList<Agency>();
		agencies = query.list();
		if (agencies.size() > 0) {
			return agencies.get(0);
		}
		return null;
	}

	@Override
	public void updateAgency(Agency agency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(agency);
	}

	@Override
	public void deleteAgency(Agency agency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.delete(agency);
	}

	@Override
	public Agency loadAgency(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		return (Agency) session.load(Agency.class, id);
	}

}

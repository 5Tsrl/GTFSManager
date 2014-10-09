package it.torino._5t.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import it.torino._5t.entity.Agency;
import it.torino._5t.entity.FareAttribute;
import it.torino._5t.persistence.HibernateUtil;

public class FareAttributeDAOImpl implements FareAttributeDAO {
	
	@Override
	public FareAttribute getFareAttribute(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from FareAttribute where id = :id");
		query.setInteger("id", id);
		List<FareAttribute> fareAttributes = new ArrayList<FareAttribute>();
		fareAttributes = query.list();
		if (fareAttributes.size() > 0) {
			return fareAttributes.get(0);
		}
		return null;
	}

	@Override
	public void updateFareAttribute(FareAttribute fareAttribute) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(fareAttribute);
	}

	@Override
	public List<FareAttribute> getAllFareAttributes() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from FareAttribute");
		return query.list();
	}

	@Override
	public List<FareAttribute> getFareAttributesFromAgency(Agency agency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from FareAttribute where agency = :agency");
		query.setEntity("agency", agency);
		return query.list();
	}

	@Override
	public void addFareAttribute(FareAttribute fareAttribute) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(fareAttribute);
	}

	@Override
	public void deleteFareAttribute(FareAttribute fareAttribute) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.delete(fareAttribute);
	}
}

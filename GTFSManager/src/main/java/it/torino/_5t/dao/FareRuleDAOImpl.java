package it.torino._5t.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import it.torino._5t.entity.FareRule;
import it.torino._5t.persistence.HibernateUtil;

public class FareRuleDAOImpl implements FareRuleDAO {

	@Override
	public FareRule getFareRule(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from FareRule where id = :id");
		query.setInteger("id", id);
		List<FareRule> fareRules = new ArrayList<FareRule>();
		fareRules = query.list();
		if (fareRules.size() > 0) {
			return fareRules.get(0);
		}
		return null;
	}

	@Override
	public List<FareRule> getAllFareRules() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from FareRule");
		return query.list();
	}

	@Override
	public void addFareRule(FareRule fareRule) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(fareRule);
	}

	@Override
	public void updateFareRule(FareRule fareRule) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(fareRule);
	}

}

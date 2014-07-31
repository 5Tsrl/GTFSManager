package it.torino._5t.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import it.torino._5t.entity.Frequency;
import it.torino._5t.persistence.HibernateUtil;

public class FrequencyDAOImpl implements FrequencyDAO {

	@Override
	public void addFrequency(Frequency frequency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(frequency);
	}

	@Override
	public void updateFrequency(Frequency frequency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(frequency);
	}

	@Override
	public void deleteFrequency(Frequency frequency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.delete(frequency);
	}

	@Override
	public Frequency getFrequency(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Frequency where id = :id");
		query.setInteger("id", id);
		List<Frequency> frequencies = new ArrayList<Frequency>();
		frequencies = query.list();
		if (frequencies.size() > 0) {
			return frequencies.get(0);
		}
		return null;
	}

	@Override
	public List<Frequency> getAllFrequencies() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Frequency");
		return query.list();
	}

}

package it.torino._5t.dao;

import it.torino._5t.entity.Transfer;
import it.torino._5t.persistence.HibernateUtil;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

public class TransferDAOImpl implements TransferDAO {

	@Override
	public List<Transfer> getAllTransfers() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Transfer");
		return query.list();
	}

	@Override
	public Transfer getTransfer(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Transfer where id = :id");
		query.setInteger("id", id);
		List<Transfer> transfers = new ArrayList<Transfer>();
		transfers = query.list();
		if (transfers.size() > 0) {
			return transfers.get(0);
		}
		return null;
	}

}

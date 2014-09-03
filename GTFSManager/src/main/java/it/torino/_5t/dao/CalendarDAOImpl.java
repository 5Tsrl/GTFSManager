package it.torino._5t.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Calendar;
import it.torino._5t.persistence.HibernateUtil;

public class CalendarDAOImpl implements CalendarDAO {

	@Override
	public List<Calendar> getAllCalendars() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Calendar");
		return query.list();
	}

	@Override
	public void addCalendar(Calendar calendar) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(calendar);
	}

	@Override
	public void updateCalendar(Calendar calendar) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(calendar);
	}

	@Override
	public void deleteCalendar(Calendar calendar) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.delete(calendar);
	}

	@Override
	public Calendar getCalendar(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Calendar where id = :id");
		query.setInteger("id", id);
		List<Calendar> calendars = new ArrayList<Calendar>();
		calendars = query.list();
		if (calendars.size() > 0) {
			return calendars.get(0);
		}
		return null;
	}

	@Override
	public Calendar loadCalendar(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		return (Calendar) session.load(Calendar.class, id);
	}

	@Override
	public List<Calendar> getCalendarsFromAgency(Agency agency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Calendar where agency = :agency");
		query.setEntity("agency", agency);
		return query.list();
	}

}

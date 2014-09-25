package it.torino._5t.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import it.torino._5t.entity.CalendarDate;
import it.torino._5t.persistence.HibernateUtil;

public class CalendarDateDAOImpl implements CalendarDateDAO {

	@Override
	public CalendarDate getCalendarDate(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from CalendarDate where id = :id");
		query.setInteger("id", id);
		List<CalendarDate> calendarDates = new ArrayList<CalendarDate>();
		calendarDates = query.list();
		if (calendarDates.size() > 0) {
			return calendarDates.get(0);
		}
		return null;
	}

	@Override
	public List<CalendarDate> getAllCalendarDates() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from CalendarDate");
		return query.list();
	}

	@Override
	public void addCalendarDate(CalendarDate calendarDate) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(calendarDate);
	}

}

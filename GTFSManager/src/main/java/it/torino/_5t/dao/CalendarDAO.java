package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.Calendar;

public interface CalendarDAO {
	public List<Calendar> getAllCalendars();
	public Calendar getCalendar(Integer id);
	public Calendar loadCalendar(Integer id);
	public void addCalendar(Calendar calendar);
	public void updateCalendar(Calendar calendar);
	public void deleteCalendar(Calendar calendar);
}

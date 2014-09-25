package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.CalendarDate;

public interface CalendarDateDAO {
	public List<CalendarDate> getAllCalendarDates();
	public CalendarDate getCalendarDate(Integer id);
	public void addCalendarDate(CalendarDate calendarDate);
}

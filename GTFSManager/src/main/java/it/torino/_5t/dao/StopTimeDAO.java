package it.torino._5t.dao;

import it.torino._5t.entity.StopTime;

import java.util.List;

public interface StopTimeDAO {
	public List<StopTime> getAllStopTimes();
	public StopTime getStopTime(Integer id);
	public void addStopTime(StopTime stopTime);
}

package it.torino._5t.dao;

import it.torino._5t.entity.Stop;

import java.util.List;

public interface StopDAO {
	public List<Stop> getAllStops();
	public Stop getStop(Integer id);
}

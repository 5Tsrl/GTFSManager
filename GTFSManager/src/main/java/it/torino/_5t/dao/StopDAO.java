package it.torino._5t.dao;

import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Stop;

import java.util.List;

public interface StopDAO {
	public List<Stop> getAllStops();
	public List<Stop> getStopsFromAgency(Agency agency);
	public Stop getStop(Integer id);
	public void addStop(Stop stop);
	public void deleteStop(Stop stop);
}

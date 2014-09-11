package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.TripPattern;

public interface TripPatternDAO {
	public List<TripPattern> getAllTripPatterns();
	public TripPattern getTripPattern(Integer id);
	public void updateTripPattern(TripPattern tripPattern);
}

package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.Route;
import it.torino._5t.entity.Trip;

public interface TripDAO {
	public void addTrip(Trip trip);
	public void updateTrip(Trip trip);
	public void deleteTrip(Trip trip);
	public Trip getTrip(Integer id);
	public Trip loadTrip(Integer id);
	public List<Trip> getAllTrips();
	public List<Trip> getTripsFromRoute(Route route);
}

package it.torino._5t.dao;

import it.torino._5t.entity.Route;

import java.util.List;

public interface RouteDAO {
	public void addRoute(Route route);
	public List<Route> getAllRoutes();
	public Route getRoute(Integer id);
	public Route loadRoute(Integer id);
	public void updateRoute(Route route);
	public void deleteRoute(Route route);
}

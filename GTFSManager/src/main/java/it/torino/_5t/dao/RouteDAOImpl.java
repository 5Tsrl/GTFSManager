package it.torino._5t.dao;

import it.torino._5t.entity.Agency;
import it.torino._5t.entity.Route;
import it.torino._5t.persistence.HibernateUtil;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

public class RouteDAOImpl implements RouteDAO {

	@Override
	public void addRoute(Route route) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(route);
	}

	@Override
	public List<Route> getAllRoutes() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Route");
		return query.list();
	}

	@Override
	public Route getRoute(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Route where id = :id");
		query.setInteger("id", id);
		List<Route> routes = new ArrayList<Route>();
		routes = query.list();
		if (routes.size() > 0) {
			return routes.get(0);
		}
		return null;
	}

	@Override
	public void updateRoute(Route route) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(route);
	}

	@Override
	public void deleteRoute(Route route) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.delete(route);
	}

	@Override
	public Route loadRoute(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		return (Route) session.load(Route.class, id);
	}

	@Override
	public List<Route> getRoutesFromAgency(Agency agency) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Route where agency = :agency");
		query.setEntity("agency", agency);
		return query.list();
	}

}

package it.torino._5t.dao;

import it.torino._5t.entity.Shape;
import it.torino._5t.persistence.HibernateUtil;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

public class ShapeDAOImpl implements ShapeDAO {

	@Override
	public List<Shape> getAllShapes() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("from Shape");
		return query.list();
	}

	@Override
	public void addShape(Shape shape) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.save(shape);
	}

	@Override
	public void updateShape(Shape shape) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.update(shape);
	}

	@Override
	public Shape loadShape(Integer id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		return (Shape) session.load(Shape.class, id);
	}

}

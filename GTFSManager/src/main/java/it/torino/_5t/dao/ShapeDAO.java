package it.torino._5t.dao;

import it.torino._5t.entity.Shape;

import java.util.List;

public interface ShapeDAO {
	public List<Shape> getAllShapes();
	public void addShape(Shape shape);
	public void updateShape(Shape shape);
	public Shape loadShape(Integer id);
}

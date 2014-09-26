package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.Zone;

public interface ZoneDAO {
	public List<Zone> getAllZones();
	public Zone getZone(Integer id);
	public void addZone(Zone zone);
	public void updateZone(Zone zone);
	public void deleteZone(Zone zone);
}

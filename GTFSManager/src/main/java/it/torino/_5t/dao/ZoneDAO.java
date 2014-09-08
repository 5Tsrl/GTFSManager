package it.torino._5t.dao;

import it.torino._5t.entity.Zone;

public interface ZoneDAO {
	public Zone getZone(Integer id);
	public void updateZone(Zone zone);
}

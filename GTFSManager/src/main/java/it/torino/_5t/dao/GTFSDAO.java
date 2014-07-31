package it.torino._5t.dao;

import it.torino._5t.entity.GTFS;

import java.util.List;

public interface GTFSDAO {
	public List<GTFS> getAllGTFSs();
	public GTFS getGTFS(Integer id);
	public void addGTFS(GTFS gtfs);
	public void deleteGTFS(GTFS gtfs);
}

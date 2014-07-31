package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.Agency;

public interface AgencyDAO {
	public void addAgency(Agency agency);
	public List<Agency> getAllAgencies();
	public Agency getAgency(Integer id);
	public Agency loadAgency(Integer id);
	public void updateAgency(Agency agency);
	public void deleteAgency(Agency agency);
}

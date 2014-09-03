package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.Agency;
import it.torino._5t.entity.FareAttribute;

public interface FareAttributeDAO {
	public List<FareAttribute> getAllFareAttributes();
	public List<FareAttribute> getFareAttributesFromAgency(Agency agency);
	public FareAttribute getFareAttribute(Integer id);
	public void updateFareAttribute(FareAttribute fareAttribute);
}

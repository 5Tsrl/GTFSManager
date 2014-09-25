package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.FareRule;

public interface FareRuleDAO {
	public List<FareRule> getAllFareRules();
	public FareRule getFareRule(Integer id);
	public void addFareRule(FareRule fareRule);
}

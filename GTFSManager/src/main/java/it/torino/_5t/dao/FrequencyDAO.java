package it.torino._5t.dao;

import java.util.List;

import it.torino._5t.entity.Frequency;

public interface FrequencyDAO {
	public void addFrequency(Frequency frequency);
	public void updateFrequency(Frequency frequency);
	public void deleteFrequency(Frequency frequency);
	public Frequency getFrequency(Integer id);
	public List<Frequency> getAllFrequencies();
}

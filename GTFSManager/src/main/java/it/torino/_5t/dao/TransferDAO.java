package it.torino._5t.dao;

import it.torino._5t.entity.Transfer;

import java.util.List;

public interface TransferDAO {
	public List<Transfer> getAllTransfers();
	public Transfer getTransfer(Integer id);
	public void addTransfer(Transfer transfer);
	public void deleteTransfer(Transfer transfer);
}

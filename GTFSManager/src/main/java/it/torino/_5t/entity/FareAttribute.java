package it.torino._5t.entity;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Size;

@Entity
@Table(name = "fare_attribute")
public class FareAttribute implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "fare_id")
	@SequenceGenerator(name = "fare_id", sequenceName = "fare_attribute_fare_id_seq")
	@Column(name = "fare_id")
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "agency_id")
	private Agency agency;
	
	@Column(name = "fare_attribute_gtfs_id")
	@Size(min = 1, max = 50, message = "Il campo \"id\" non può essere vuoto")
	private String gtfsId;
	
	@Column(name = "price")
	private double price;
	
	@Column(name = "currency_type")
	@Size(min = 3, max = 3, message = "Il campo \"valuta\" non può essere vuoto")
	private String currencyType;
	
	@Column(name = "payment_method")
	@Min(0)
	@Max(1)
	private int paymentMethod;
	
	@Column(name = "transfers")
	@Min(0)
	@Max(2)
	private Integer transfers;
	
	@Column(name = "transfer_duration")
	private Integer transferDuration;
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "fareAttribute")
	private Set<FareRule> fareRules = new HashSet<FareRule>();

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		FareAttribute other = (FareAttribute) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Agency getAgency() {
		return agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public String getGtfsId() {
		return gtfsId;
	}

	public void setGtfsId(String gtfsId) {
		this.gtfsId = gtfsId;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getCurrencyType() {
		return currencyType;
	}

	public void setCurrencyType(String currencyType) {
		this.currencyType = currencyType;
	}

	public int getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(int paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public Integer getTransfers() {
		return transfers;
	}

	public void setTransfers(Integer transfers) {
		this.transfers = transfers;
	}

	public Integer getTransferDuration() {
		return transferDuration;
	}

	public void setTransferDuration(Integer transferDuration) {
		this.transferDuration = transferDuration;
	}

	public Set<FareRule> getFareRules() {
		return fareRules;
	}

	public void setFareRules(Set<FareRule> fareRules) {
		this.fareRules = fareRules;
	}
	
	public void addFareRule(FareRule fareRule) {
		fareRule.setFareAttribute(this);
		fareRules.add(fareRule);
	}
}

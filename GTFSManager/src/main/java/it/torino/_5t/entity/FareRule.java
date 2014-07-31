package it.torino._5t.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name = "fare_rule")
public class FareRule implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "fare_rule_id")
	@SequenceGenerator(name = "fare_rule_id", sequenceName = "fare_rule_fare_rule_id_seq")
	@Column(name = "fare_rule_id")
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "fare_id")
	private FareAttribute fareAttribute;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "route_id")
	private Route route;
	
	// TODO
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "origin_id")
	private Zone origin;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "destination_id")
	private Zone destination;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "contains_id")
	private Zone contains;

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
		FareRule other = (FareRule) obj;
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

	public FareAttribute getFareAttribute() {
		return fareAttribute;
	}

	public void setFareAttribute(FareAttribute fareAttribute) {
		this.fareAttribute = fareAttribute;
	}

	public Route getRoute() {
		return route;
	}

	public void setRoute(Route route) {
		this.route = route;
	}

	public Zone getOrigin() {
		return origin;
	}

	public void setOrigin(Zone origin) {
		this.origin = origin;
	}

	public Zone getDestination() {
		return destination;
	}

	public void setDestination(Zone destination) {
		this.destination = destination;
	}

	public Zone getContains() {
		return contains;
	}

	public void setContains(Zone contains) {
		this.contains = contains;
	}
}

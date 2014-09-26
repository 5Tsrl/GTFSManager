package it.torino._5t.entity;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

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
import javax.validation.constraints.Size;

@Entity
@Table(name = "zone")
public class Zone implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "zone_id")
	@SequenceGenerator(name = "zone_id", sequenceName = "zone_zone_id_seq")
	@Column(name = "zone_id")
	private Integer id;
	
	@Column(name = "zone_gtfs_id")
	@Size(min = 1, max = 50, message = "Il campo \"id\" non può essere vuoto")
	private String gtfsId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "agency_id")
	private Agency agency;
	
	@Column(name = "name")
	@Size(min = 1, max = 255, message = "Il campo \"nome\" non può essere vuoto")
	private String name;
	
	//TODO
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "origin")
	private Set<FareRule> originFareRules = new HashSet<FareRule>();
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "destination")
	private Set<FareRule> destinationFareRules = new HashSet<FareRule>();
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "contains")
	private Set<FareRule> containsFareRules = new HashSet<FareRule>();
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "zone")
	private Set<Stop> stops = new HashSet<Stop>();

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
		Zone other = (Zone) obj;
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

	public String getGtfsId() {
		return gtfsId;
	}

	public void setGtfsId(String gtfsId) {
		this.gtfsId = gtfsId;
	}

	public Agency getAgency() {
		return agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Set<FareRule> getOriginFareRules() {
		return originFareRules;
	}

	public void setOriginFareRules(Set<FareRule> originFareRules) {
		this.originFareRules = originFareRules;
	}

	public Set<FareRule> getDestinationFareRules() {
		return destinationFareRules;
	}

	public void setDestinationFareRules(Set<FareRule> destinationFareRules) {
		this.destinationFareRules = destinationFareRules;
	}

	public Set<FareRule> getContainsFareRules() {
		return containsFareRules;
	}

	public void setContainsFareRules(Set<FareRule> containsFareRules) {
		this.containsFareRules = containsFareRules;
	}

	public Set<Stop> getStops() {
		return stops;
	}

	public void setStops(Set<Stop> stops) {
		this.stops = stops;
	}
	
	public void addOriginFareRule(FareRule fareRule) {
		fareRule.setOrigin(this);
		originFareRules.add(fareRule);
	}
	
	public void addDestinationFareRule(FareRule fareRule) {
		fareRule.setDestination(this);
		destinationFareRules.add(fareRule);
	}
	
	public void addStop(Stop stop) {
		stop.setZone(this);
		stops.add(stop);
	}
}

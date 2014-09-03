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

import org.hibernate.validator.constraints.URL;

@Entity
@Table(name = "route")
public class Route implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "route_id")
	@SequenceGenerator(name = "route_id", sequenceName = "route_route_id_seq")
	@Column(name = "route_id")
	private Integer id;
	
	@Column(name = "route_gtfs_id")
	@Size(min = 1, max = 50, message = "Il campo \"id\" non può essere vuoto")
	private String gtfsId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "agency_id")
	private Agency agency;
	
	@Column(name = "route_short_name")
	@Size(min = 1, max = 50, message = "Il campo \"nome abbreviato\" non può essere vuoto")
	private String shortName;
	
	@Column(name = "route_long_name")
	@Size(min = 1, max = 255, message = "Il campo \"nome completo\" non può essere vuoto")
	private String longName;
	
	@Column(name = "route_desc")
	@Size(max = 255)
	private String description;
	
	@Column(name = "route_type")
	@Min(0)
	@Max(7)
	private int type;
	
	@Column(name = "route_url")
	@Size(max = 255)
	@URL(message = "L'url inserita non è corretta")
	private String url;
	
	@Column(name = "route_color")
	@Size(max = 7)
	private String color;
	
	@Column(name = "route_text_color")
	@Size(max = 7)
	private String textColor;
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "route")
	private Set<Trip> trips = new HashSet<Trip>();
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "route")
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
		Route other = (Route) obj;
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

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public String getLongName() {
		return longName;
	}

	public void setLongName(String longName) {
		this.longName = longName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getTextColor() {
		return textColor;
	}

	public void setTextColor(String textColor) {
		this.textColor = textColor;
	}

	public Set<Trip> getTrips() {
		return trips;
	}

	public void setTrips(Set<Trip> trips) {
		this.trips = trips;
	}
	
	public Set<FareRule> getFareRules() {
		return fareRules;
	}

	public void setFareRules(Set<FareRule> fareRules) {
		this.fareRules = fareRules;
	}

	public void addTrip(Trip trip) {
		trip.setRoute(this);
		trips.add(trip);
	}
	
	public void addFareRule(FareRule fareRule) {
		fareRule.setRoute(this);
		fareRules.add(fareRule);
	}
}

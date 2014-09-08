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
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.URL;

@Entity
@Table(name = "agency")
public class Agency implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "agency_id")
	@SequenceGenerator(name = "agency_id", sequenceName = "agency_agency_id_seq")
	@Column(name = "agency_id")
	private Integer id;
	
	@Column(name = "agency_gtfs_id")
	@Size(min = 1, max = 50, message = "Il campo \"id\" non può essere vuoto")
	private String gtfsId;
	
	@Column(name = "agency_name")
	@Size(min = 1, max = 255, message = "Il campo \"nome\" non può essere vuoto")
	private String name;
	
	@Column(name = "agency_url")
	@Size(min = 1, max = 255, message = "Il campo \"sito web\" non può essere vuoto")
	@URL(message = "Il sito web inserito non corrisponde a un url corretta")
	private String url;
	
	@Column(name = "agency_timezone")
	@NotNull
	private String timezone;
	
	@Column(name = "agency_lang")
	@Size(min = 2, max = 2, message = "Il campo \"lingua\" non può essere vuoto")
	private String language;
	
	@Column(name = "agency_phone")
	@Size(max = 20)
	private String phone;
	
	@Column(name = "agency_fare_url")
	@Size(max = 255)
	@URL(message = "Il sito web inserito non corrisponde a un url corretta")
	private String fareUrl;
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "agency")
	private Set<Route> routes = new HashSet<Route>();
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "agency")
	private Set<Calendar> calendars = new HashSet<Calendar>();
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "agency")
	private Set<FareAttribute> fareAttributes = new HashSet<FareAttribute>();
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "agency")
	private Set<Stop> stops = new HashSet<Stop>();
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "agency")
	private Set<Shape> shapes = new HashSet<Shape>();
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "agency")
	private Set<Zone> zones = new HashSet<Zone>();

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
		Agency other = (Agency) obj;
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getTimezone() {
		return timezone;
	}

	public void setTimezone(String timezone) {
		this.timezone = timezone;
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getFareUrl() {
		return fareUrl;
	}

	public void setFareUrl(String fareUrl) {
		this.fareUrl = fareUrl;
	}

	public Set<Route> getRoutes() {
		return routes;
	}

	public void setRoutes(Set<Route> routes) {
		this.routes = routes;
	}
	
	public Set<Calendar> getCalendars() {
		return calendars;
	}

	public void setCalendars(Set<Calendar> calendars) {
		this.calendars = calendars;
	}
	
	public Set<FareAttribute> getFareAttributes() {
		return fareAttributes;
	}

	public void setFareAttributes(Set<FareAttribute> fareAttributes) {
		this.fareAttributes = fareAttributes;
	}

	public Set<Stop> getStops() {
		return stops;
	}

	public void setStops(Set<Stop> stops) {
		this.stops = stops;
	}

	public Set<Shape> getShapes() {
		return shapes;
	}

	public void setShapes(Set<Shape> shapes) {
		this.shapes = shapes;
	}

	public Set<Zone> getZones() {
		return zones;
	}

	public void setZones(Set<Zone> zones) {
		this.zones = zones;
	}

	public void addRoute(Route route) {
		route.setAgency(this);
		routes.add(route);
	}
	
	public void addCalendar(Calendar calendar) {
		calendar.setAgency(this);
		calendars.add(calendar);
	}
	
	public void addFareAttribute(FareAttribute fareAttribute) {
		fareAttribute.setAgency(this);
		fareAttributes.add(fareAttribute);
	}
	
	public void addStop(Stop stop) {
		stop.setAgency(this);
		stops.add(stop);
	}
	
	public void addShape(Shape shape) {
		shape.setAgency(this);
		shapes.add(shape);
	}
	
	public void addZone(Zone zone) {
		zone.setAgency(this);
		zones.add(zone);
	}
}

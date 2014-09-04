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
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.URL;

@Entity
@Table(name = "stop")
public class Stop implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "stop_id")
	@SequenceGenerator(name = "stop_id", sequenceName = "stop_stop_id_seq")
	@Column(name = "stop_id")
	private Integer id;
	
	@Column(name = "stop_gtfs_id")
	@Size(min = 1, max = 50, message = "Il campo \"id\" non può essere vuoto")
	private String gtfsId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "agency_id")
	private Agency agency;
	
	@Column(name = "stop_code")
	@Size(max = 20)
	private String code;
	
	@Column(name = "stop_name")
	@Size(min = 1, max = 50, message = "Il campo \"nome\" non può essere vuoto")
	private String name;
	
	@Column(name = "stop_desc")
	@Size(max = 255)
	private String desc;
	
	@Column(name = "stop_lat")
	private double lat;
	
	@Column(name = "stop_lon")
	private double lon;
	
	// TODO
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "zone_id")
	private Zone zone;
	
	@Column(name = "stop_url")
	@Size(max = 255)
	@URL(message = "Il sito web inserito non corrisponde a un url corretta")
	private String url;
	
	@Column(name = "location_type")
	@Min(0)
	@Max(1)
	private Integer locationType;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "parent_station")
	private Stop parentStation;
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "parentStation")
	private Set<Stop> stops = new HashSet<Stop>();
	
	@Column(name = "stop_timezone")
	private String timezone;
	
	@Column(name = "wheelchair_boarding")
	@Min(0)
	@Max(2)
	private Integer wheelchairBoarding;
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "stop")
	private Set<StopTime> stopTimes = new HashSet<StopTime>();
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "fromStop")
	private Set<Transfer> fromStopTransfers = new HashSet<Transfer>();
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "toStop")
	private Set<Transfer> toStopTransfers = new HashSet<Transfer>();

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
		Stop other = (Stop) obj;
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

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public double getLat() {
		return lat;
	}

	public void setLat(double lat) {
		this.lat = lat;
	}

	public double getLon() {
		return lon;
	}

	public void setLon(double lon) {
		this.lon = lon;
	}

	public Zone getZone() {
		return zone;
	}

	public void setZone(Zone zone) {
		this.zone = zone;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Integer getLocationType() {
		return locationType;
	}

	public void setLocationType(Integer locationType) {
		this.locationType = locationType;
	}

	public Stop getParentStation() {
		return parentStation;
	}

	public void setParentStation(Stop parentStation) {
		this.parentStation = parentStation;
	}

	public Set<Stop> getStops() {
		return stops;
	}

	public void setStops(Set<Stop> stops) {
		this.stops = stops;
	}

	public String getTimezone() {
		return timezone;
	}

	public void setTimezone(String timezone) {
		this.timezone = timezone;
	}

	public Integer getWheelchairBoarding() {
		return wheelchairBoarding;
	}

	public void setWheelchairBoarding(Integer wheelchairBoarding) {
		this.wheelchairBoarding = wheelchairBoarding;
	}
	
	public Set<StopTime> getStopTimes() {
		return stopTimes;
	}
	
	public void setStopTimes(Set<StopTime> stopTimes) {
		this.stopTimes = stopTimes;
	}

	public Set<Transfer> getFromStopTransfers() {
		return fromStopTransfers;
	}

	public void setFromStopTransfers(Set<Transfer> fromStopTransfers) {
		this.fromStopTransfers = fromStopTransfers;
	}

	public Set<Transfer> getToStopTransfers() {
		return toStopTransfers;
	}

	public void setToStopTransfers(Set<Transfer> toStopTransfers) {
		this.toStopTransfers = toStopTransfers;
	}
	
	public void addStopTime(StopTime stopTime) {
		stopTime.setStop(this);
		stopTimes.add(stopTime);
	}
	
	public void addChildStop(Stop stop) {
		stop.setParentStation(this);
		stops.add(stop);
	}
}

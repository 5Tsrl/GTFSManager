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
@Table(name = "trip")
public class Trip implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "trip_id")
	@SequenceGenerator(name = "trip_id", sequenceName = "trip_trip_id_seq")
	@Column(name = "trip_id")
	private Integer id;
	
	@Column(name = "trip_gtfs_id")
	@Size(min = 1, max = 50, message = "Il campo \"id\" non può essere vuoto")
	private String gtfsId;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "route_id")
	private Route route;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "service_id")
	private Calendar calendar;
	
	@Column(name = "trip_headsign")
	@Size(max = 50)
	private String tripHeadsign;
	
	@Column(name = "trip_short_name")
	@Size(max = 50)
	private String tripShortName;
	
	@Column(name = "direction_id")
	@Min(0)
	@Max(1)
	private Integer directionId;
	
	@JoinColumn(name = "block_id")
	@Size(max = 50)
	private String blockId;
	
	@ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
	@JoinColumn(name = "shape_id")
	private Shape shape;
	
	@Column(name = "wheelchair_accessible")
	@Min(0)
	@Max(2)
	private Integer wheelchairAccessible;
	
	@Column(name = "bikes_allowed")
	@Min(0)
	@Max(2)
	private Integer bikesAllowed;
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "trip")
	private Set<Frequency> frequencies = new HashSet<Frequency>();
	
	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval=true, mappedBy = "trip")
	private Set<StopTime> stopTimes = new HashSet<StopTime>();

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
		Trip other = (Trip) obj;
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

	public Route getRoute() {
		return route;
	}

	public void setRoute(Route route) {
		this.route = route;
	}

	public Calendar getCalendar() {
		return calendar;
	}

	public void setCalendar(Calendar calendar) {
		this.calendar = calendar;
	}

	public String getTripHeadsign() {
		return tripHeadsign;
	}

	public void setTripHeadsign(String tripHeadsign) {
		this.tripHeadsign = tripHeadsign;
	}

	public String getTripShortName() {
		return tripShortName;
	}

	public void setTripShortName(String tripShortName) {
		this.tripShortName = tripShortName;
	}

	public Integer getDirectionId() {
		return directionId;
	}

	public void setDirectionId(Integer directionId) {
		this.directionId = directionId;
	}

	public String getBlockId() {
		return blockId;
	}

	public void setBlockId(String blockId) {
		this.blockId = blockId;
	}

	public Shape getShape() {
		return shape;
	}

	public void setShape(Shape shape) {
		this.shape = shape;
	}

	public Integer getWheelchairAccessible() {
		return wheelchairAccessible;
	}

	public void setWheelchairAccessible(Integer wheelchairAccessible) {
		this.wheelchairAccessible = wheelchairAccessible;
	}

	public Integer getBikesAllowed() {
		return bikesAllowed;
	}

	public void setBikesAllowed(Integer bikesAllowed) {
		this.bikesAllowed = bikesAllowed;
	}

	public Set<Frequency> getFrequencies() {
		return frequencies;
	}

	public Set<StopTime> getStopTimes() {
		return stopTimes;
	}

	public void setStopTimes(Set<StopTime> stopTimes) {
		this.stopTimes = stopTimes;
	}

	public void setFrequencies(Set<Frequency> frequencies) {
		this.frequencies = frequencies;
	}
	
	public void addFrequency(Frequency frequency) {
		frequency.setTrip(this);
		frequencies.add(frequency);
	}
	
	public void addStopTime(StopTime stopTime) {
		stopTime.setTrip(this);
		stopTimes.add(stopTime);
	}
}

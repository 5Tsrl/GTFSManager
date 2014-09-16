package it.torino._5t.entity;

import java.io.Serializable;
import java.sql.Time;

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
	
	@Column(name = "start_time")
	private Time startTime;
	
	@Column(name = "end_time")
	private Time endTime;
	
	@Column(name = "headway_secs")
	@Min(1)
	private Integer headwaySecs;
	
	@Column(name = "exact_times")
	@Min(0)
	@Max(1)
	private Integer exactTimes;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "trip_pattern_id")
	private TripPattern tripPattern;
	
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
	
	@Column(name = "block_id")
	@Size(max = 50)
	private String blockId;
	
	@Column(name = "single_trip")
	private boolean singleTrip;
	
	@ManyToOne(fetch = FetchType.LAZY)
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

	public Trip() {}
	
	public Trip(String gtfsId, Time startTime, Time endTime,
			Integer headwaySecs, Integer exactTimes, Route route,
			String tripHeadsign, String tripShortName, Integer directionId,
			String blockId, boolean singleTrip, Shape shape,
			Integer wheelchairAccessible, Integer bikesAllowed) {
		super();
		this.gtfsId = gtfsId;
		this.startTime = startTime;
		this.endTime = endTime;
		this.headwaySecs = headwaySecs;
		this.exactTimes = exactTimes;
		this.route = route;
		this.tripHeadsign = tripHeadsign;
		this.tripShortName = tripShortName;
		this.directionId = directionId;
		this.blockId = blockId;
		this.singleTrip = singleTrip;
		this.shape = shape;
		this.wheelchairAccessible = wheelchairAccessible;
		this.bikesAllowed = bikesAllowed;
	}

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

	public TripPattern getTripPattern() {
		return tripPattern;
	}

	public void setTripPattern(TripPattern tripPattern) {
		this.tripPattern = tripPattern;
	}

	public Time getStartTime() {
		return startTime;
	}

	public void setStartTime(Time startTime) {
		this.startTime = startTime;
	}

	public Time getEndTime() {
		return endTime;
	}

	public void setEndTime(Time endTime) {
		this.endTime = endTime;
	}

	public Integer getHeadwaySecs() {
		return headwaySecs;
	}

	public void setHeadwaySecs(Integer headwaySecs) {
		this.headwaySecs = headwaySecs;
	}

	public Integer getExactTimes() {
		return exactTimes;
	}

	public void setExactTimes(Integer exactTimes) {
		this.exactTimes = exactTimes;
	}

	public String getBlockId() {
		return blockId;
	}

	public void setBlockId(String blockId) {
		this.blockId = blockId;
	}

	public boolean isSingleTrip() {
		return singleTrip;
	}

	public void setSingleTrip(boolean singleTrip) {
		this.singleTrip = singleTrip;
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
}

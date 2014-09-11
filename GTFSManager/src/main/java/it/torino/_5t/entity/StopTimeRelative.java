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
@Table(name = "stop_time_relative")
public class StopTimeRelative implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "stop_time_relative_id")
	@SequenceGenerator(name = "stop_time_relative_id", sequenceName = "stop_time_relative_stop_time_relative_id_seq")
	@Column(name = "stop_time_relative_id")
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "trip_pattern_id")
	private TripPattern tripPattern;
	
	@Column(name = "relative_arrival_time")
	private Time relativeArrivalTime;
	
	@Column(name = "relative_departure_time")
	private Time relativeDepartureTime;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "stop_id")
	private Stop stop;
	
	@Column(name = "stop_sequence")
	@Min(1)
	private Integer stopSequence;
	
	@Column(name = "stop_headsign")
	@Size(max = 50)
	private String stopHeadsign;
	
	@Column(name = "pickup_type")
	@Min(0)
	@Max(3)
	private Integer pickupType;
	
	@Column(name = "drop_off_type")
	@Min(0)
	@Max(3)
	private Integer dropOffType;
	
	//TODO
	@Column(name = "shape_dist_traveled")
	private Double shapeDistTraveled;

	public StopTimeRelative() {
	}

	public StopTimeRelative(Time relativeArrivalTime,
			Time relativeDepartureTime, Integer stopSequence,
			String stopHeadsign, Integer pickupType, Integer dropOffType,
			Double shapeDistTraveled) {
		super();
		this.relativeArrivalTime = relativeArrivalTime;
		this.relativeDepartureTime = relativeDepartureTime;
		this.stopSequence = stopSequence;
		this.stopHeadsign = stopHeadsign;
		this.pickupType = pickupType;
		this.dropOffType = dropOffType;
		this.shapeDistTraveled = shapeDistTraveled;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((relativeArrivalTime == null) ? 0 : relativeArrivalTime.hashCode());
		result = prime * result
				+ ((relativeDepartureTime == null) ? 0 : relativeDepartureTime.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result
				+ ((stopSequence == null) ? 0 : stopSequence.hashCode());
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
		StopTimeRelative other = (StopTimeRelative) obj;
		if (relativeArrivalTime == null) {
			if (other.relativeArrivalTime != null)
				return false;
		} else if (!relativeArrivalTime.equals(other.relativeArrivalTime))
			return false;
		if (relativeDepartureTime == null) {
			if (other.relativeDepartureTime != null)
				return false;
		} else if (!relativeDepartureTime.equals(other.relativeDepartureTime))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (stopSequence == null) {
			if (other.stopSequence != null)
				return false;
		} else if (!stopSequence.equals(other.stopSequence))
			return false;
		return true;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public TripPattern getTripPattern() {
		return tripPattern;
	}

	public void setTripPattern(TripPattern tripPattern) {
		this.tripPattern = tripPattern;
	}

	public Time getRelativeArrivalTime() {
		return relativeArrivalTime;
	}

	public void setRelativeArrivalTime(Time relativeArrivalTime) {
		this.relativeArrivalTime = relativeArrivalTime;
	}

	public Time getRelativeDepartureTime() {
		return relativeDepartureTime;
	}

	public void setRelativeDepartureTime(Time relativeDepartureTime) {
		this.relativeDepartureTime = relativeDepartureTime;
	}

	public Stop getStop() {
		return stop;
	}

	public void setStop(Stop stop) {
		this.stop = stop;
	}

	public Integer getStopSequence() {
		return stopSequence;
	}

	public void setStopSequence(Integer stopSequence) {
		this.stopSequence = stopSequence;
	}

	public String getStopHeadsign() {
		return stopHeadsign;
	}

	public void setStopHeadsign(String stopHeadsign) {
		this.stopHeadsign = stopHeadsign;
	}

	public Integer getPickupType() {
		return pickupType;
	}

	public void setPickupType(Integer pickupType) {
		this.pickupType = pickupType;
	}

	public Integer getDropOffType() {
		return dropOffType;
	}

	public void setDropOffType(Integer dropOffType) {
		this.dropOffType = dropOffType;
	}

	public Double getShapeDistTraveled() {
		return shapeDistTraveled;
	}

	public void setShapeDistTraveled(Double shapeDistTraveled) {
		this.shapeDistTraveled = shapeDistTraveled;
	}
}

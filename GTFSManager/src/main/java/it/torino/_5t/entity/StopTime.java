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
@Table(name = "stop_time")
public class StopTime implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "stop_time_id")
	@SequenceGenerator(name = "stop_time_id", sequenceName = "stop_time_stop_time_id_seq")
	@Column(name = "stop_time_id")
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "trip_id")
	private Trip trip;
	
	@Column(name = "arrival_time")
	private Time arrivalTime;
	
	@Column(name = "departure_time")
	private Time departureTime;
	
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

	public StopTime() {
	}

	public StopTime(Time arrivalTime, Time departureTime,
			Integer stopSequence, String stopHeadsign, Integer pickupType,
			Integer dropOffType, Double shapeDistTraveled) {
		super();
		this.arrivalTime = arrivalTime;
		this.departureTime = departureTime;
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
				+ ((arrivalTime == null) ? 0 : arrivalTime.hashCode());
		result = prime * result
				+ ((departureTime == null) ? 0 : departureTime.hashCode());
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
		StopTime other = (StopTime) obj;
		if (arrivalTime == null) {
			if (other.arrivalTime != null)
				return false;
		} else if (!arrivalTime.equals(other.arrivalTime))
			return false;
		if (departureTime == null) {
			if (other.departureTime != null)
				return false;
		} else if (!departureTime.equals(other.departureTime))
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

	public Trip getTrip() {
		return trip;
	}

	public void setTrip(Trip trip) {
		this.trip = trip;
	}

	public Time getArrivalTime() {
		return arrivalTime;
	}

	public void setArrivalTime(Time arrivalTime) {
		this.arrivalTime = arrivalTime;
	}

	public Time getDepartureTime() {
		return departureTime;
	}

	public void setDepartureTime(Time departureTime) {
		this.departureTime = departureTime;
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

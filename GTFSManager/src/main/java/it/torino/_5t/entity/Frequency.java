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

@Entity
@Table(name = "frequency")
public class Frequency implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "frequency_id")
	@SequenceGenerator(name = "frequency_id", sequenceName = "frequency_frequency_id_seq")
	@Column(name = "frequency_id")
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "trip_id")
	private Trip trip;
	
	@Column(name = "start_time")
	private Time startTime;
	
	@Column(name = "end_time")
	private Time endTime;
	
	@Column(name = "headway_secs")
	@Min(1)
	private int headwaySecs;
	
	@Column(name = "exact_times")
	@Min(0)
	@Max(1)
	private Integer exactTimes;
	
	public Frequency() {
	}

	public Frequency(Trip trip, Time startTime, Time endTime, int headwaySecs,
			Integer exactTimes) {
		super();
		this.trip = trip;
		this.startTime = startTime;
		this.endTime = endTime;
		this.headwaySecs = headwaySecs;
		this.exactTimes = exactTimes;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((endTime == null) ? 0 : endTime.hashCode());
		result = prime * result + headwaySecs;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result
				+ ((startTime == null) ? 0 : startTime.hashCode());
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
		Frequency other = (Frequency) obj;
		if (endTime == null) {
			if (other.endTime != null)
				return false;
		} else if (!endTime.equals(other.endTime))
			return false;
		if (headwaySecs != other.headwaySecs)
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (startTime == null) {
			if (other.startTime != null)
				return false;
		} else if (!startTime.equals(other.startTime))
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

	public int getHeadwaySecs() {
		return headwaySecs;
	}

	public void setHeadwaySecs(int headwaySecs) {
		this.headwaySecs = headwaySecs;
	}

	public Integer getExactTimes() {
		return exactTimes;
	}

	public void setExactTimes(Integer exactTimes) {
		this.exactTimes = exactTimes;
	}
}

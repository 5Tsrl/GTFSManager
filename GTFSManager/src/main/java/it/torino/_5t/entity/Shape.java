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
@Table(name = "shape")
public class Shape implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "shape_id")
	@SequenceGenerator(name = "shape_id", sequenceName = "shape_shape_id_seq")
	@Column(name = "shape_id")
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "agency_id")
	private Agency agency;
	
	@Column(name = "shape_encoded_polyline")
	@Size(max=1000000)
	private String encodedPolyline;
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "shape")
	private Set<TripPattern> tripPatterns = new HashSet<TripPattern>();
	
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
		Shape other = (Shape) obj;
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
	
	public Agency getAgency() {
		return agency;
	}

	public void setAgency(Agency agency) {
		this.agency = agency;
	}
	/*
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

	public int getSequence() {
		return sequence;
	}

	public void setSequence(int sequence) {
		this.sequence = sequence;
	}

	public Double getShapeDistTraveled() {
		return shapeDistTraveled;
	}

	public void setShapeDistTraveled(Double shapeDistTraveled) {
		this.shapeDistTraveled = shapeDistTraveled;
	}
*/
	public String getEncodedPolyline() {
		return encodedPolyline;
	}

	public void setEncodedPolyline(String encodedPolyline) {
		this.encodedPolyline = encodedPolyline;
	}
	
	public Set<TripPattern> getTripPatterns() {
		return tripPatterns;
	}

	public void setTripPatterns(Set<TripPattern> tripPatterns) {
		this.tripPatterns = tripPatterns;
	}

	public void addTripPattern(TripPattern tripPattern) {
		tripPattern.setShape(this);
		tripPatterns.add(tripPattern);
	}
}

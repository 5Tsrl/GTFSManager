package it.torino._5t.entity;

import java.io.Serializable;

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
@Table(name = "transfer")
public class Transfer implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "transfer_id")
	@SequenceGenerator(name = "transfer_id", sequenceName = "transfer_transfer_id_seq")
	@Column(name = "transfer_id")
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "agency_id")
	private Agency agency;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "from_stop_id")
	private Stop fromStop;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "to_stop_id")
	private Stop toStop;
	
	@Column(name = "transfer_type")
	@Min(0)
	@Max(3)
	private Integer transferType;
	
	@Column(name = "min_transfer_time")
	@Min(0)
	private Integer minTransferTime;

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
		Transfer other = (Transfer) obj;
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

	public Stop getFromStop() {
		return fromStop;
	}

	public void setFromStop(Stop fromStop) {
		this.fromStop = fromStop;
	}

	public Stop getToStop() {
		return toStop;
	}

	public void setToStop(Stop toStop) {
		this.toStop = toStop;
	}

	public Integer getTransferType() {
		return transferType;
	}

	public void setTransferType(Integer transferType) {
		this.transferType = transferType;
	}

	public Integer getMinTransferTime() {
		return minTransferTime;
	}

	public void setMinTransferTime(Integer minTransferTime) {
		this.minTransferTime = minTransferTime;
	}
}

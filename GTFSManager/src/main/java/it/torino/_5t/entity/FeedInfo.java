package it.torino._5t.entity;

import java.io.Serializable;
import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.URL;

@Entity
@Table(name = "feed_info")
public class FeedInfo implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "feed_info_id")
	@SequenceGenerator(name = "feed_info_id", sequenceName = "feed_info_feed_info_id_seq")
	@Column(name = "feed_info_id")
	private Integer id;
	
	@Column(name = "feed_publisher_name")
	@Size(min = 1, max = 50, message = "Il campo \"nome\" non può essere vuoto")
	private String publisherName;
	
	@Column(name = "feed_publisher_url")
	@Size(min = 1, max = 255, message = "Il campo \"sito web\" non può essere vuoto")
	@URL(message = "Il sito web inserito non corrisponde a un url corretta")
	private String publisherUrl;
	
	@Column(name = "feed_lang")
	@Size(min = 1, max = 20, message = "Il campo \"lingua\" non può essere vuoto")
	private String language;
	
	@Column(name = "feed_start_date")
	private Date startDate;
	
	@Column(name = "feed_end_date")
	private Date endDate;
	
	@Column(name = "feed_version")
	@Size(max = 20)
	private String version;
	
	@Column(name = "feed_name")
	@Size(min = 1, max = 50, message = "Il campo \"nome\" non può essere vuoto")
	private String name;
	
	@Column(name = "feed_description")
	@Size(max = 255)
	private String description;

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
		FeedInfo other = (FeedInfo) obj;
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

	public String getPublisherName() {
		return publisherName;
	}

	public void setPublisherName(String publisherName) {
		this.publisherName = publisherName;
	}

	public String getPublisherUrl() {
		return publisherUrl;
	}

	public void setPublisherUrl(String publisherUrl) {
		this.publisherUrl = publisherUrl;
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
}

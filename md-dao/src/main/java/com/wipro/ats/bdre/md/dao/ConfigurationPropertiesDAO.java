package com.wipro.ats.bdre.md.dao;

import com.wipro.ats.bdre.exception.MetadataException;
import com.wipro.ats.bdre.md.dao.jpa.ConfigurationProperties;
import com.wipro.ats.bdre.md.dao.jpa.ConfigurationPropertiesId;
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by cloudera on 6/8/17.
 */
@Transactional
@Service
public class ConfigurationPropertiesDAO {
    private static final Logger LOGGER = Logger.getLogger(ConfigurationPropertiesDAO.class);
    @Autowired
    SessionFactory sessionFactory;

    public ConfigurationPropertiesId insert(ConfigurationProperties configurationProperties) {
        Session session = sessionFactory.openSession();
        ConfigurationPropertiesId configurationPropertiesId = null;
        try {
            session.beginTransaction();
            configurationPropertiesId = (ConfigurationPropertiesId) session.save(configurationProperties);
            session.getTransaction().commit();
        } catch (MetadataException e) {
            session.getTransaction().rollback();
            LOGGER.error(e);
        } finally {
            session.close();
        }
        return configurationPropertiesId;
    }
}

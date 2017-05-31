package com.wipro.ats.bdre.md.rest;

import com.wipro.ats.bdre.md.beans.table.Process;
import com.wipro.ats.bdre.md.dao.ConnectionPropertiesDAO;
import com.wipro.ats.bdre.md.dao.ConnectionsDAO;
import com.wipro.ats.bdre.md.dao.jpa.ConnectionProperties;
import com.wipro.ats.bdre.md.dao.jpa.Connections;
import com.wipro.ats.bdre.md.rest.util.Dao2TableUtil;
import com.wipro.ats.bdre.md.rest.util.DateConverter;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by cloudera on 5/30/17.
 */
@Controller
@RequestMapping("/connections")
public class ConnectionsAPI {
    private static final Logger LOGGER = Logger.getLogger(ConnectionsAPI.class);
    @Autowired
    private ConnectionsDAO connectionsDAO;
    @Autowired
    private ConnectionPropertiesDAO connectionPropertiesDAO;

    @RequestMapping(value = {"/createconnection"}, method = RequestMethod.POST)

    @ResponseBody
    public
    RestWrapper createJob(@RequestParam Map<String, String> map, Principal principal) {
        LOGGER.debug(" value of map is " + map.size());
        RestWrapper restWrapper = null;

        List<ConnectionProperties> connectionPropertiesList = new ArrayList<>();
        ConnectionProperties connectionProperties = null;
        String connectionName = "";
        String connectionType = "";
        for (String string : map.keySet()) {
            LOGGER.debug("String is" + string);
            if (map.get(string) == null || ("").equals(map.get(string))) {
                continue;
            }

            Integer splitIndex = string.lastIndexOf("_");
            String key = string.substring(splitIndex + 1, string.length());
            LOGGER.debug("key is " + key);
            if(string.startsWith("type")){
                connectionType =  map.get(string);
            }
            else  if(string.startsWith("connectionName")){
                connectionName =  map.get(string);
            }
            else if (string.startsWith("source_")) {
                connectionProperties = Dao2TableUtil.buildJPAConnectionProperties("source", key, map.get(string), "Properties for source");
                connectionPropertiesList.add(connectionProperties);
            } else if (string.startsWith("emitter_")) {
                connectionProperties = Dao2TableUtil.buildJPAConnectionProperties("emitter", key, map.get(string), "Properties for emitter");
                connectionPropertiesList.add(connectionProperties);
            } else if (string.startsWith("persistentStores_")) {
                connectionProperties = Dao2TableUtil.buildJPAConnectionProperties("persistentStore",  key, map.get(string), "Properties for persistentStore");
                connectionPropertiesList.add(connectionProperties);
            }
        }

        Connections connections = new Connections();
        connections.setConnectionName(connectionName);
        connections.setConnectionType(connectionType);

        connectionsDAO.insert(connections);

        for(ConnectionProperties jpaConnectionProperties: connectionPropertiesList){
            jpaConnectionProperties.setConnections(connections);
            jpaConnectionProperties.getId().setConnectionName(connectionName);
            connectionPropertiesDAO.insert(jpaConnectionProperties);
        }


        restWrapper = new RestWrapper(connections, RestWrapper.OK);
        LOGGER.info("Connection saved by " + principal.getName());


        return restWrapper;
    }


}

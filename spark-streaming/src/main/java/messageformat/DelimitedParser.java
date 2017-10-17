package messageformat;

import com.wipro.ats.bdre.md.api.GetProperties;
import com.wipro.ats.bdre.md.api.StreamingMessagesAPI;
import com.wipro.ats.bdre.md.dao.jpa.Messages;

import java.util.Properties;

/**
 * Created by cloudera on 5/21/17.
 */
public class DelimitedParser implements MessageParser{
     public Object[] parseRecord(String record, Integer pid) throws Exception{
         try {

             System.out.println("pid inside delimited log parser = " + pid);

             GetProperties getProperties = new GetProperties();
             Properties properties = getProperties.getProperties(pid.toString(), "message");
             String messageName = properties.getProperty("messageName");
             StreamingMessagesAPI streamingMessagesAPI = new StreamingMessagesAPI();
             Messages messages = streamingMessagesAPI.getMessage(messageName);

             String delimiter = messages.getDelimiter();
             String columns = messages.getMessageSchema();

             String[] parsedRecords = record.split(delimiter);
             Object[] outputRecords = new Object[parsedRecords.length];
             String[] columnsArray = columns.split(",");
             for(int i=0; i<columnsArray.length; i++){
                 String dataType= columnsArray[i].substring(columnsArray[i].indexOf(":")+1);
                 if(dataType.equalsIgnoreCase("Integer") || dataType.equalsIgnoreCase("Long")){
                     outputRecords[i] = Long.parseLong(parsedRecords[i]);
                 }
                 else if(dataType.equalsIgnoreCase("Short")){
                     outputRecords[i] = Short.parseShort(parsedRecords[i]);
                 }
                 else if(dataType.equalsIgnoreCase("Byte")){
                     outputRecords[i] = Byte.parseByte(parsedRecords[i]);
                 }
                 else if(dataType.equalsIgnoreCase("Float")){
                     outputRecords[i] = Float.parseFloat(parsedRecords[i]);
                 }
                 else if(dataType.equalsIgnoreCase("Double")){
                     outputRecords[i] = Double.parseDouble(parsedRecords[i]);
                 }
                 else if(dataType.equalsIgnoreCase("Boolean")){
                     outputRecords[i] = Boolean.parseBoolean(parsedRecords[i]);
                 }
                 else {
                     outputRecords[i] = parsedRecords[i];
                 }
             }

             return outputRecords;
         }catch (Exception e){
             System.out.println("e = " + e);
             e.printStackTrace();
             throw e;
         }
     }
}


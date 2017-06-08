package datasources;

import com.wipro.ats.bdre.md.api.GetProperties;
import com.wipro.ats.bdre.md.beans.GetPropertiesInfo;
import kafka.serializer.StringDecoder;
import org.apache.spark.streaming.api.java.JavaDStream;
import org.apache.spark.streaming.api.java.JavaPairInputDStream;
import org.apache.spark.streaming.api.java.JavaStreamingContext;
import org.apache.spark.streaming.kafka.KafkaUtils;
import scala.Tuple2;

import java.util.*;

/**
 * Created by cloudera on 5/19/17.
 */
public class KafkaSource implements Source{

    Map<String,String> kafkaParams;
    Set<String> topics = new HashSet<>();
    String topicName=new String();

    //TODO fetch props from DB
    public Map<String,String> getKafkaParams(int pid){
        GetProperties getProperties=new GetProperties();
        Map<String,String> kafkaParams = new  HashMap<String,String>();
       // List<GetPropertiesInfo> propertiesInfoList= (List<GetPropertiesInfo>) getProperties.getProperties(String.valueOf(pid),"kafka");
        Properties kafkaProperties=  getProperties.getProperties(String.valueOf(pid),"kafka");
        Enumeration e = kafkaProperties.propertyNames();
        if (!kafkaProperties.isEmpty()) {
            while (e.hasMoreElements()) {
                String key = (String) e.nextElement();
                kafkaParams.put(key,kafkaProperties.getProperty(key));
            }
        }

        //TODO changenow
        kafkaParams.put("metadata.broker.list", "localhost:9092");
        kafkaParams.put("zookeeper.connect", "localhost:2181");
        return kafkaParams;
    }

    public Set<String> getTopics(int pid){
        GetProperties getProperties=new GetProperties();
        Properties kafkaProperties=  getProperties.getProperties(String.valueOf(pid),"kafka");
        topicName = kafkaProperties.getProperty("Topic Name");
        String[] topicArray = topicName.split(",");
        for(int i=0;i<topicArray.length;i++){
            System.out.println("topic = " + topicArray[i]);
            topics.add(topicArray[i]);
        }
        return topics;
    }

    @Override
    public JavaDStream execute(JavaStreamingContext ssc,Integer pid) {
        System.out.println("pid = " + pid);
        Map<String, String> kafkaParams = getKafkaParams(pid);

        //TODO changenow
        //Set<String> topics = getTopics(pid);
        Set<String> topics = Collections.singleton("test");
        System.out.println("topics = " + topics);
        JavaPairInputDStream<String, String> directKafkaStream = KafkaUtils.createDirectStream(ssc, String.class, String.class, StringDecoder.class, StringDecoder.class, kafkaParams, topics);
        return directKafkaStream.map(Tuple2::_2);
    }

}

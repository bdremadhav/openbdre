package analytics;

import com.wipro.ats.bdre.md.api.GetProperties;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.broadcast.Broadcast;
import org.apache.spark.ml.Pipeline;
import org.apache.spark.ml.classification.LogisticRegression;
import org.apache.spark.ml.feature.StringIndexer;
import org.apache.spark.ml.feature.VectorAssembler;
import org.apache.spark.ml.regression.LinearRegressionModel;
import org.apache.spark.sql.DataFrame;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SQLContext;
import org.apache.spark.sql.types.StructType;
import org.apache.spark.streaming.api.java.JavaPairDStream;
import org.apache.spark.streaming.api.java.JavaStreamingContext;
import scala.Tuple2;
import util.WrapperMessage;

import java.util.*;

/**
 * Created by cloudera on 10/11/17.
 */
public class LinearRegression implements Analytics {
    @Override
    public JavaPairDStream<String, WrapperMessage> transform(JavaRDD emptyRDD, Map<Integer, JavaPairDStream<String, WrapperMessage>> prevDStreamMap, Map<Integer, Set<Integer>> prevMap, Integer pid, StructType schema, Map<String, Broadcast<HashMap<String, String>>> broadcastMap, JavaStreamingContext jssc) {
        List<Integer> prevPidList = new ArrayList<>();
        prevPidList.addAll(prevMap.get(pid));
        Integer prevPid = prevPidList.get(0);
        JavaPairDStream<String,WrapperMessage> prevDStream = prevDStreamMap.get(prevPid);

        GetProperties getProperties = new GetProperties();
        /*Properties lrProperties = getProperties.getProperties(String.valueOf(pid), "linear-regression");
        String continuousColumns = lrProperties.getProperty("continuous-columns");
        String[] continuousColumnsArray = continuousColumns.split(",");
        String categoryColumns = lrProperties.getProperty("category-columns");
        String[] categoryColumnsArray = categoryColumns.split(",");
        Double elasticNetParam = Double.parseDouble(lrProperties.getProperty("elastic-net-param"));
        Integer maxIter = Integer.parseInt(lrProperties.getProperty("max-iterations"));
        Double regParam = Double.parseDouble(lrProperties.getProperty("reg-param"));
        String check = lrProperties.getProperty("check");*/


        Properties lrProperties = getProperties.getProperties(String.valueOf(pid), "linear-regression");
        String continuousColumns = "Temperature,AmbientPressure,RelativeHumidity,ExhaustVacuum,ElectricalEnergy";
        String[] continuousColumnsArray = continuousColumns.split(",");
        String categoryColumns = "";
        String[] categoryColumnsArray = categoryColumns.split(",");
        Double elasticNetParam = 0.8;
        Integer maxIter = 10;
        Double regParam = 0.3;
        String check = "training";

        ArrayList<String> features = new ArrayList<String>(Arrays.asList(continuousColumnsArray));
        for(String categoryCol : categoryColumnsArray) {
            if(!categoryCol.equals(""))
                features.add(categoryCol+"Index");
        }
        String[] featureColumns = new String[features.size()];
        for(int i=0; i< features.size(); i++){
            featureColumns[i] = features.get(i);
        }

        JavaPairDStream<String,WrapperMessage> lrDstream = prevDStream.transformToPair(new Function<JavaPairRDD<String, WrapperMessage>, JavaPairRDD<String, WrapperMessage>>() {
            @Override
            public JavaPairRDD<String, WrapperMessage> call(JavaPairRDD<String, WrapperMessage> rddPairWrapperMessage) throws Exception {
                System.out.println("beginning of linear regression = " + new Date().getTime() +"for pid = "+pid);
                JavaRDD<Row> rddRow = rddPairWrapperMessage.map(s -> s._2.getRow());
                SQLContext sqlContext = SQLContext.getOrCreate(rddRow.context());
                DataFrame dataFrame = sqlContext.createDataFrame(rddRow, schema);
                DataFrame outputDF = null;
                if(dataFrame != null){
                    for(String categoryCol : categoryColumnsArray) {
                        StringIndexer indexer = new StringIndexer().setInputCol(categoryCol).setOutputCol(categoryCol+"Index");
                    }

                    VectorAssembler assembler = new VectorAssembler().setInputCols(featureColumns).setOutputCol("features");
                    DataFrame assembyDF = assembler.transform(dataFrame);
                    assembyDF.show(10);

                    org.apache.spark.ml.regression.LinearRegression lr = new org.apache.spark.ml.regression.LinearRegression().setMaxIter(maxIter).setRegParam(regParam).setElasticNetParam(elasticNetParam);

                    if(check.equalsIgnoreCase("training")) {
                        LinearRegressionModel lrModel = null;
                        lrModel = lr.fit(assembyDF);
                        lrModel.save("/tmp/"+pid+"/"+pid);
                        System.out.println("lrModel.coefficients() = " + lrModel.coefficients());
                    }
                    else {
                        LinearRegressionModel predictionLRModel = LinearRegressionModel.load("/tmp/"+pid+"/"+pid);
                        outputDF = predictionLRModel.transform(assembyDF);
                    }

                }
                JavaPairRDD<String,WrapperMessage> finalRDD = null;
                if (outputDF != null)
                    finalRDD = outputDF.javaRDD().mapToPair(s -> new Tuple2<String,WrapperMessage>(null,new WrapperMessage(s)));
                System.out.println("End of linear regression = " + new Date().getTime() +"for pid = "+pid);
                return finalRDD;

            }

        });
        lrDstream.print();
        return lrDstream;
    }
}

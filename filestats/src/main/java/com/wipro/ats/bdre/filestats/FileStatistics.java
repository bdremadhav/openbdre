package com.wipro.ats.bdre.filestats;

/**
 * Created by cloudera on 1/30/17.
 */
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.SparkConf;
import org.apache.spark.sql.DataFrame;
import org.apache.spark.sql.SQLContext;
import org.apache.spark.sql.types.*;

public class FileStatistics {

    public static void main(String[] args) {


        SparkConf conf = new SparkConf().setAppName("statistics using spark").setMaster("local");
        JavaSparkContext sc = new JavaSparkContext(conf);

        SQLContext sqlContext = new SQLContext(sc);
        StructType customSchema = new StructType(new StructField[]{
                new StructField("year", DataTypes.IntegerType, true, Metadata.empty()),
                new StructField("make", DataTypes.StringType, true, Metadata.empty()),
                new StructField("model", DataTypes.StringType, true, Metadata.empty()),
                new StructField("comment", DataTypes.StringType, true, Metadata.empty()),
                new StructField("blank", DataTypes.StringType, true, Metadata.empty())
        });

        DataFrame df = sqlContext.read()
                .format("com.databricks.spark.csv")
                .schema(customSchema)
                .option("header", "true")
                .load("cars.csv");


        df.select("year", "model").printSchema();
    }

}

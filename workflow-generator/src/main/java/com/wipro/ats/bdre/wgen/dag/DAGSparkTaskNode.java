package com.wipro.ats.bdre.wgen.dag;

import com.wipro.ats.bdre.md.api.GetProperties;
import com.wipro.ats.bdre.md.beans.ProcessInfo;
import com.wipro.ats.bdre.wgen.dag.GenericActionNode;
import com.wipro.ats.bdre.wgen.dag.LOFActionNode;
import com.wipro.ats.bdre.wgen.dag.DAGNode;
import org.apache.log4j.Logger;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Enumeration;

/**
 * Created by SU324335 on 7/1/16.
 */
public class DAGSparkTaskNode extends GenericActionNode {
    private static final Logger LOGGER = Logger.getLogger(DAGSparkTaskNode.class);
    private ProcessInfo processInfo = new ProcessInfo();
    private DAGTaskNode dagTaskNode = null;

    /**
     * This constructor is used to set node id and process information.
     *
     * @param dagTaskNode An instance of ActionNode class which a workflow triggers the execution of a task.
     */
    public DAGSparkTaskNode(DAGTaskNode dagTaskNode) {
        setId(dagTaskNode.getId());
        processInfo = dagTaskNode.getProcessInfo();
        this.dagTaskNode = dagTaskNode;
    }

    public ProcessInfo getProcessInfo() {
        return processInfo;
    }


    public String getName() {

        String nodeName = "dag-spark-" + getId() + "-" + processInfo.getProcessName().replace(' ', '_');
        return nodeName.substring(0, Math.min(nodeName.length(), 45));

    }

    @Override
    public String getDAG() {
        LOGGER.info("Inside dag Spark");
        if (this.getProcessInfo().getParentProcessId() == 0) {
            return "";
        }
        DAGNode fileListNode = null;
        for (DAGNode dagNode : dagTaskNode.getContainingNodes()) {
          if (dagNode instanceof LOFActionNode) {
                fileListNode = dagNode;   //TODO
            }
        }
        StringBuilder ret = new StringBuilder();
        ret.append("\n<action name=\"" + getName());
        if (isSecurityEnabled(this.getProcessInfo().getParentProcessId(), "security") != 0) {
            ret.append(" cred='spark_credentials'");
        }

        ret.append("\">\n" +
                "   <java>\n" +
                "        <job-tracker>${jobTracker}</job-tracker>\n" +
                "        <name-node>${nameNode}</name-node>\n" +
                "        <main-class>org.apache.spark.deploy.SparkSubmit</main-class>\n" +
                "        <arg>--class</arg>\n");
        ret.append(getAppMainClass(getId(), "spark-main"));
        ret.append(getConf(getId(), "spark-conf"));
        ret.append("        <arg>" + getJarName(getId(), "spark-jar") + "</arg>\n");
        ret.append(getAppArgs(getId(), "app-args"));
        ret.append("        <file>" + getJarName(getId(), "spark-jar") + "</file>\n");
        ret.append("     </java>\n" +
                "        <ok to=\"" + getToNode().getName() + "\"/>\n" +
                "        <error to=\"" + getTermNode().getName() + "\"/>\n" +
                "    </action>");

        //return ret.toString();
        try {
            FileWriter fw = new FileWriter("/home/cloudera/defFile.txt", true);
            fw.write("\nf_"+getName().replace('-', '_')+"()");
            fw.close();
        }
        catch (IOException e){
            System.out.println("e = " + e);
        }
        return "\ndef "+ getName().replace('-','_')+"_pc():\n" +
                "\tcommand='java -cp /home/cloudera/bdre/lib/spark-core/spark-core-1.1-SNAPSHOT.jar:/home/cloudera/bdre/lib/*/* org.apache.spark.deploy.SparkSubmit  " +" "+getJarName(getId(), "spark-jar")+getAppArgs(getId(), "app-args")+"',\n" +
                "\tbash_output = os.system(command)\n" +
                "\tif(bash_output == 0):\n" +
                "\t\treturn '"+getToNode().getName().replace('-', '_') +"'\n" +
                "\telse:\n" +
                "\t\treturn '"+getTermNode().getName().replace('-', '_') +"'\n" +

                "\ndef f_"+ getName().replace('-','_')+"():\n" +
                "\t"+ getName().replace('-', '_')+".set_downstream("+ getToNode().getName().replace('-', '_')+")\n" +
                "\t"+ getName().replace('-','_')+".set_downstream("+ getTermNode().getName().replace('-', '_')+")\n" +

                getName().replace('-', '_')+" = BranchPythonOperator(task_id='" + getName().replace('-', '_')+"', python_callable="+getName().replace('-','_')+"_pc, dag=dag)\n";

    }

    /**
     * This method gets path for spark jar file
     *
     * @param pid         process-id of Spark Job.
     * @param configGroup config_group entry in properties table "jar" for spark jar file path
     * @return String name of the jar
     */
    public String getJarName(Integer pid, String configGroup) {
        GetProperties getProperties = new GetProperties();
        java.util.Properties jarPath = getProperties.getProperties(getId().toString(), configGroup);
        Enumeration e = jarPath.propertyNames();
        StringBuilder addJarPath = new StringBuilder();
        if (!jarPath.isEmpty()) {
            while (e.hasMoreElements()) {
                String key = (String) e.nextElement();
                addJarPath.append(jarPath.getProperty(key));
            }
        } else {
            addJarPath.append("spark-" + getId() + ".jar");
        }

        return addJarPath.toString();
    }

    /**
     * This method gets all the extra configuration required for spark job
     *
     * @param pid         process-id of spark job
     * @param configGroup config_group entry in properties table "param" for arguments
     * @return String containing arguments to be appended to workflow string.
     */
    public String getConf(Integer pid, String configGroup) {
        GetProperties getProperties = new GetProperties();
        java.util.Properties listForParams = getProperties.getProperties(getId().toString(), configGroup);
        Enumeration e = listForParams.propertyNames();
        StringBuilder addParams = new StringBuilder();
        if (!listForParams.isEmpty()) {
            while (e.hasMoreElements()) {
                String key = (String) e.nextElement();
                addParams.append(" --" + key);
                addParams.append(" " + listForParams.getProperty(key) + " ");
            }
        }
        return addParams.toString();
    }

    /**
     * This method gets all the extra configuration required for spark job
     *
     * @param pid         process-id of spark job
     * @param configGroup config_group entry in properties table "param" for arguments
     * @return String containing arguments to be appended to workflow string.
     */
    public String getAppArgs(Integer pid, String configGroup) {
        GetProperties getProperties = new GetProperties();
        java.util.Properties listForParams = getProperties.getProperties(getId().toString(), configGroup);
        Enumeration e = listForParams.propertyNames();
        StringBuilder addParams = new StringBuilder();
        if (!listForParams.isEmpty()) {
            while (e.hasMoreElements()) {
                String key = (String) e.nextElement();
                addParams.append(" "+listForParams.getProperty(key)+" ");
            }
        }
        return addParams.toString();
    }

    public Integer isSecurityEnabled(Integer pid, String configGroup) {
        GetProperties getProperties = new GetProperties();
        java.util.Properties properties = getProperties.getProperties(pid.toString(), configGroup);
        return properties.size();
    }

    /**
     * This method gets main class for MapReduce Job
     *
     * @param pid         process-id of Spark Job
     * @param configGroup config_group entry in properties table "program" for class name
     * @return String containing main class to be appended to workflow string
     */
    public String getAppMainClass(Integer pid, String configGroup) {
        GetProperties getProperties = new GetProperties();
        java.util.Properties className = getProperties.getProperties(getId().toString(), configGroup);
        Enumeration e = className.propertyNames();
        StringBuilder addClassName = new StringBuilder();
        if (!className.isEmpty()) {
            while (e.hasMoreElements()) {
                String key = (String) e.nextElement();
                addClassName.append(" "+className.getProperty(key)+" ");

            }
        } else {
            addClassName.append(" "+getId()+" ");
        }
        return addClassName.toString();
    }
}
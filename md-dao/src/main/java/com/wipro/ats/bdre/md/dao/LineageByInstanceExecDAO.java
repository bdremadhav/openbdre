/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.wipro.ats.bdre.md.dao;

import com.wipro.ats.bdre.exception.MetadataException;
import com.wipro.ats.bdre.md.beans.GetLineageByInstanceExecInfo;
import com.wipro.ats.bdre.md.dao.jpa.*;
import com.wipro.ats.bdre.md.dao.jpa.Process;
import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by PR324290 on 11/4/2015.
 */
@Transactional
@Service
public class LineageByInstanceExecDAO {
    private static final Logger LOGGER = Logger.getLogger(LineageByInstanceExecDAO.class);
    @Autowired
    SessionFactory sessionFactory;

    public List<GetLineageByInstanceExecInfo> LineageByInstanceExec(GetLineageByInstanceExecInfo getLineageByInstanceExecInfo) {
        Session session = sessionFactory.openSession();
        List<GetLineageByInstanceExecInfo> outputlist = new ArrayList<GetLineageByInstanceExecInfo>();

        try {
            session.beginTransaction();
            //Batch batch=(Batch)session.get(Batch.class,getLineageByInstanceExecInfo.getInstanceExecId());
            List<Batch> batches = new ArrayList<Batch>();
            if (session.get(InstanceExec.class, getLineageByInstanceExecInfo.getInstanceExecId()) != null) {
                batches = session.createCriteria(Batch.class).add(Restrictions.eq("instanceExec", session.get(InstanceExec.class, getLineageByInstanceExecInfo.getInstanceExecId()))).list();
                LOGGER.info("Total number os batches satisfying the given condition is " + batches.size());
                InstanceExec instanceExec = (InstanceExec) session.get(InstanceExec.class, getLineageByInstanceExecInfo.getInstanceExecId());
                Process process = (Process) session.get(Process.class, instanceExec.getProcess().getProcessId());
                LOGGER.info("processid of the process is" + instanceExec.getProcess().getProcessId());
                Iterator iterator1 = batches.iterator();

                while (iterator1.hasNext()) {
                    Batch batch = (Batch) iterator1.next();
                    List<BatchConsumpQueue> listbcq = session.createCriteria(BatchConsumpQueue.class).add(Restrictions.eq("batchByTargetBatchId", batch)).list();
                    Iterator iterator = listbcq.iterator();
                    while (iterator.hasNext()) {
                        BatchConsumpQueue batchConsumpQueue = (BatchConsumpQueue) iterator.next();
                        GetLineageByInstanceExecInfo getLineageByInstanceExecInfo1 = new GetLineageByInstanceExecInfo();
                        getLineageByInstanceExecInfo1.setExecState(instanceExec.getExecStatus().getExecStateId());
                        getLineageByInstanceExecInfo1.setInstanceExecId(instanceExec.getInstanceExecId());
                        getLineageByInstanceExecInfo1.setProcessDesc(process.getDescription());
                        getLineageByInstanceExecInfo1.setProcessName(process.getProcessName());
                        getLineageByInstanceExecInfo1.setProcessId(process.getProcessId());
                        getLineageByInstanceExecInfo1.setTargetBatchId(getLineageByInstanceExecInfo.getTargetBatchId());
                        getLineageByInstanceExecInfo1.setSourceBatchId(batchConsumpQueue.getBatchBySourceBatchId().getBatchId());
                        getLineageByInstanceExecInfo1.setStartTime(new java.sql.Timestamp(batch.getInstanceExec().getStartTs().getTime()));
                        if (batch.getInstanceExec().getEndTs() != null)
                            getLineageByInstanceExecInfo1.setEndTime(new java.sql.Timestamp(batch.getInstanceExec().getEndTs().getTime()));
                        outputlist.add(getLineageByInstanceExecInfo1);
                    }


                    List<ArchiveConsumpQueue> listacq = session.createCriteria(ArchiveConsumpQueue.class).add(Restrictions.eq("batchByTargetBatchId", batch)).list();
                    Iterator iterator2 = listacq.iterator();
                    while (iterator2.hasNext()) {
                        ArchiveConsumpQueue archiveConsumpQueue = (ArchiveConsumpQueue) iterator2.next();
                        GetLineageByInstanceExecInfo getLineageByInstanceExecInfo1 = new GetLineageByInstanceExecInfo();
                        getLineageByInstanceExecInfo1.setExecState(instanceExec.getExecStatus().getExecStateId());
                        getLineageByInstanceExecInfo1.setInstanceExecId(instanceExec.getInstanceExecId());
                        getLineageByInstanceExecInfo1.setProcessDesc(process.getDescription());
                        getLineageByInstanceExecInfo1.setProcessName(process.getProcessName());
                        getLineageByInstanceExecInfo1.setProcessId(process.getProcessId());
                        getLineageByInstanceExecInfo1.setTargetBatchId(getLineageByInstanceExecInfo.getTargetBatchId());
                        getLineageByInstanceExecInfo1.setSourceBatchId(archiveConsumpQueue.getBatchBySourceBatchId().getBatchId());
                        getLineageByInstanceExecInfo1.setStartTime(new java.sql.Timestamp(batch.getInstanceExec().getStartTs().getTime()));
                        getLineageByInstanceExecInfo1.setEndTime(new java.sql.Timestamp(batch.getInstanceExec().getEndTs().getTime()));
                        outputlist.add(getLineageByInstanceExecInfo1);
                    }
                }
                LOGGER.info("Total size of returnig beans is" + outputlist.size());
                session.getTransaction().commit();
            }
        } catch (MetadataException e) {
            session.getTransaction().rollback();
            LOGGER.error(e);
        } finally {
            session.close();
        }
        return outputlist;

    }

}
